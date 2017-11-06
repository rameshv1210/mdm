package com.softsuave.demo.service;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.security.cert.CertificateException;
import java.util.Base64;
import java.util.Date;
import java.util.List;
import java.util.UUID;

import org.apache.log4j.Logger;
import org.bouncycastle.cms.CMSException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.google.android.gcm.server.Message;
import com.google.android.gcm.server.Sender;
import com.notnoop.apns.APNS;
import com.notnoop.apns.ApnsService;
import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.model.UserDevice;
import com.softsuave.demo.model.UserIdentity;
import com.softsuave.demo.repository.UserCommandRepository;
import com.softsuave.demo.repository.UserDeviceRepository;
import com.softsuave.demo.repository.UserIdentityRepository;
import com.softsuave.demo.request.model.Request;
import com.softsuave.demo.utils.MDMUtils;

@Service
public class MdmServiceImpl implements MdmService {

	private static final Logger LOGGER = Logger.getLogger(MdmServiceImpl.class);

	private static final String IOS = "ios";
	private static final String ANDROID = "Android";

	@Autowired
	ApnsService apnsService;

	@Autowired
	Sender sender;

	@Autowired
	UserIdentityRepository userIdentityRepository;

	@Autowired
	UserDeviceRepository userDeviceRepository;

	@Autowired
	UserCommandRepository userCommandRepository;

	@Value("${policy.path}")
	String defaultPolicyPath;

	@Value("${certificate.path}")
	String certPath;

	@Value("${profile.path}")
	String profilePath;

	@Value("${identity.path}")
	String identityCertPath;


	/***
	 * 
	 * @param abTicket
	 * @param userId
	 * @throws InterruptedException 
	 * @throws IOException 
	 */
	@Override
	public void validateAbTicket(String abTicket, Long userId) throws IOException, InterruptedException {

		String[] result = userIdentityRepository.userKeyByUserId(userId);

		if (result == null) {
			LOGGER.error("Login failed due to invalid userId");
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "Invalid user detail"));
		}

		String ticket = MDMUtils.decryptTicket(result[0], (result[1] != null && !result[1].trim().isEmpty()) ? result[1].trim() : null , abTicket);

		String requestUserId = ticket.substring(0, ticket.indexOf("||||"));
		Long ticketTimeInSec = Long.parseLong(ticket.substring(ticket.indexOf("||||") + 4, ticket.length()));

		if(Long.parseLong(requestUserId) != userId) {
			LOGGER.error("Login failed due to userId mismatch");
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "Invalid user detail"));
		}

		if(new Date().getTime() - (ticketTimeInSec * 1000) > (60 * 60 * 1000)) {
			LOGGER.error("Login failed due to timout");
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.UNAUTHORIZED, "session expired. Please try again"));
		}

	}


	/***
	 * Service method for creating identity certificate for new user.
	 *  
	 */
	@Override
	public String createIdentityCertificate(String userId) {
		try {

			MDMUtils.createIdentityCertificate(certPath, userId);

			String identityCert = Base64.getEncoder().encodeToString(
					Files.readAllBytes(Paths.get(identityCertPath + userId + ".p12")));
			String serialNumber = MDMUtils.readCertificate(identityCertPath, userId);

			userIdentityRepository.saveUserIdentity(Long.parseLong(userId),
					identityCert, serialNumber);

			String profileConfig = new String(Files.readAllBytes(Paths.get(defaultPolicyPath)));
			profileConfig = profileConfig.replace("{identityKey}", identityCert);

			MDMUtils.createProfile(profilePath, userId, profileConfig);
			MDMUtils.signProfile(certPath, userId);

			return serialNumber;
		} catch (IOException | InterruptedException | CertificateException e) {
			LOGGER.error("Exception while creating profile", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while creating profile"));
		}
	}


	/***
	 * This method is used to find device certificate for every request.
	 * 
	 */
	@Override
	public Long identifyUser(String request, String signature) {
		String certSerialNumber;
		try {
			certSerialNumber = MDMUtils.verifySignature(signature, request);
		} catch (CMSException | UnsupportedEncodingException e) {
			LOGGER.error("Exception while verifying certificate", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while verifying certificate"));
		}

		UserIdentity userIdentity;
		if (certSerialNumber != null) {
			userIdentity = userIdentityRepository.userIdentityBySerialNumber(certSerialNumber);
			if(userIdentity == null) {
				LOGGER.error("User not found for given certificate");
				throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.NOT_FOUND, "User not found for given certificate"));
			}
		} else {
			LOGGER.error("Given certificate is not valid");
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.NOT_FOUND, "Given certificate is not valid"));
		}
		return userIdentity.getUserId();
	}


	/***
	 * This method is used to find user details based on serial number.
	 * 
	 */
	@Override
	public UserIdentity identifyUser(String serialNumber) {
		UserIdentity userIdentity = userIdentityRepository.userIdentityBySerialNumber(serialNumber);

		if (userIdentity == null) {
			LOGGER.error("user not found");
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.NOT_FOUND, "User not found"));
		}

		return userIdentity;
	}


	/***
	 * This method handle sending push notification to device.
	 * 
	 */
	@Override
	public void sendPush(Request request){

		List<UserDevice> userDevices = userDeviceRepository.findUserDevice(
				request.getCompanyId(), request.getGroupId(),
				request.getUserId().trim().isEmpty() ? 0L : Long.parseLong(request.getUserId()), 
				request.getDeviceUdid(), request.getDeviceType());

		Message msg = new Message.Builder().build();

		try {
			for(UserDevice userDevice : userDevices){
				if(userDevice.getDeviceType().equalsIgnoreCase(IOS)){

					apnsService.push(userDevice.getDeviceToken(), APNS.newPayload().mdm(userDevice.getDevicePushMagic()).build());

				} else if(userDevice.getDeviceType().equalsIgnoreCase(ANDROID)){

					sender.send(msg, userDevice.getDeviceToken(), 1);

				}
			}
		} catch (IOException e) {
			LOGGER.error("Exception while sending push notification", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while sending push notification"));
		}

		userCommandRepository.updatePushTime(
				request.getCompanyId(), request.getGroupId(),
				request.getUserId().trim().isEmpty() ? 0L : Long.parseLong(request.getUserId()), 
				request.getDeviceUdid(), request.getDeviceType());
	}


	/***
	 * This method receives device command and update it in database.
	 * 
	 */
	@Override
	public void receiveDeviceCommand(Request request) {

		userCommandRepository.savedeviceCommand(
				request.getCompanyId(), request.getGroupId(),
				request.getUserId().trim().isEmpty() ? 0L : Long.parseLong(request.getUserId()), 
				request.getDeviceUdid(), request.getDeviceType(), 
				request.getCommandType(), request.getCommand(), UUID.randomUUID().toString());
	}


	/***
	 * This method receives device command and update it in database.
	 * and send push notification to device.
	 * 
	 */
	@Override
	public void executeDeviceCommand(Request request) {

		userCommandRepository.savedeviceCommand(
				request.getCompanyId(), request.getGroupId(),
				request.getUserId().trim().isEmpty() ? 0L : Long.parseLong(request.getUserId()), 
				request.getDeviceUdid(), request.getDeviceType(), 
				request.getCommandType(), request.getCommand(), UUID.randomUUID().toString());

		sendPush(request);
	}

}
