package com.softsuave.demo.service;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.List;

import org.apache.log4j.Logger;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.dd.plist.NSDictionary;
import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.model.UserIdentity;
import com.softsuave.demo.repository.IosCommandResultRepository;
import com.softsuave.demo.repository.UserIdentityRepository;
import com.softsuave.demo.request.model.Request;

@Service
public class IOSMdmServiceImpl implements IOSMdmService {

	private static final Logger LOGGER = Logger.getLogger(IOSMdmServiceImpl.class);

	@Autowired
	MdmService mdmService;

	@Autowired
	IOSMdmHelperService iOSMdmHelperService;

	@Autowired
	UserIdentityRepository userIdentityRepository;
	
	@Autowired
	IosCommandResultRepository iosCommandResultRepository;

	@Value("${profile.path}")
	String profilePath;


	/***
	 * This method provides functionalities to validate user abTicket.
	 * 
	 */
	@Override
	public void validateTicket(String userId, String abTicket) {

		try {
			mdmService.validateAbTicket(abTicket, Long.parseLong(userId));

		} catch (AlertBootException e) {
			throw e;
		} catch (Exception e){
			LOGGER.error("Exception while processing login process", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Error while processing. Please try again"));
		}

	}


	/***
	 * This method provides functionalities to create identity
	 * certificate and send back a signed profile to device.
	 * 
	 */
	@Override
	public byte[] enrollService(String userId) {

		try {
			UserIdentity userIdentity = userIdentityRepository.userIdentityByUserId(Long.parseLong(userId));

			if (userIdentity == null) {
				mdmService.createIdentityCertificate(userId);
			}

			byte[] profile = null;
			profile = Files.readAllBytes(Paths.get(profilePath + userId + "_sign.mobileconfig"));
			return profile;

		} catch (IOException e){
			LOGGER.error("Exception while fetching profile", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while fetching profile"));
		}

	}


	/***
	 * This method authenticate device after successful installation of profile
	 * and store device details in database.
	 * 
	 */
	@Override
	public void checkInService(String request, String signature) {

		LOGGER.info(request);

		Long userId = mdmService.identifyUser(request, signature);

		NSDictionary dictionary = iOSMdmHelperService.parseRequestToPlist(request);

		iOSMdmHelperService.processDeviceMessage(dictionary, userId);
		
		String udid = dictionary.objectForKey("UDID").toString();
		
		updateLatestPolicyToDevice(userId, udid);
		
		sendNotificationToNodeServer(userId, udid);
	}


	private void sendNotificationToNodeServer(Long userId, String deviceUUID) {
		try {
			JSONObject request = new JSONObject();
			request.put("user_id", userId);
			request.put("device_uuid", deviceUUID);
			URL notifyUrl = new URL("http://localhost:8888/mdmserver/checkinDevice");
			HttpURLConnection newConnection = (HttpURLConnection) notifyUrl.openConnection();
			newConnection.setRequestMethod("POST");
			newConnection.setRequestProperty("Accept", "application/json");
			newConnection.setRequestProperty("Content-Type", "application/json");
			newConnection.setUseCaches(false);
			newConnection.setDoOutput(true);

			DataOutputStream wr = new DataOutputStream(newConnection.getOutputStream());
			String string = request.toString();
			wr.writeBytes(string);
			wr.flush();
			wr.close();
			newConnection.connect();
			if (newConnection.getResponseCode() == HttpURLConnection.HTTP_OK) {

				BufferedReader br = new BufferedReader(new InputStreamReader(newConnection.getInputStream()));
				StringBuilder sb = new StringBuilder();
				String line;
				while ((line = br.readLine()) != null) {
					sb.append(line + "\n");
				}
				br.close();
				request = new JSONObject(sb.toString());
				LOGGER.info("Status: " + request.optString("status") + "; Message: " + request.optString("message"));
			} else {
				LOGGER.error("Call CheckInDevice Failed");
			}
		} catch (Exception e) {
			LOGGER.error("Call CheckInDevice Failed", e);
		}

	}


	/***
	 * This method process command status and provide new commands to be executed.
	 * 
	 */
	@Override
	public byte[] commandService(String request, String signature){
		try {
			LOGGER.info(request);

			Long userId = mdmService.identifyUser(request, signature);

			NSDictionary dictionary = iOSMdmHelperService.parseRequestToPlist(request);

			return iOSMdmHelperService.processDeviceRequest(dictionary, userId);

		} catch (Exception e){
			LOGGER.error("Exception while processing command", e);
			return null;
		}
	}
	
	private void updateLatestPolicyToDevice(Long userId, String deviceUuid) {
		List<Object[]> deviceCommands = iosCommandResultRepository.getDeviceCommand(userId, deviceUuid, "ios");
		Request request = new Request();
		for (Object[] deviceCommand : deviceCommands) {
			List<Object> deviceCommandList = Arrays.asList(deviceCommand);
			if (!deviceCommandList.isEmpty() && deviceCommandList.size() >= 4) {
				request.setCompanyId((String) deviceCommandList.get(0));
				request.setGroupId((String) deviceCommandList.get(1));
				request.setUserId(String.valueOf(userId));
				request.setDeviceUdid(deviceUuid);
				request.setDeviceType("ios");
				request.setCommand((String) deviceCommandList.get(2));
				request.setCommandType((String) deviceCommandList.get(3));
				mdmService.executeDeviceCommand(request);
			}
		}
	}

}
