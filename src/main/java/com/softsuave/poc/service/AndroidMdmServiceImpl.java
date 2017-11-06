package com.softsuave.poc.service;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.softsuave.poc.exception.AlertBootErrorMessage;
import com.softsuave.poc.exception.AlertBootException;
import com.softsuave.poc.model.UserCommand;
import com.softsuave.poc.model.UserIdentity;
import com.softsuave.poc.repository.UserCommandRepository;
import com.softsuave.poc.repository.UserDeviceRepository;
import com.softsuave.poc.repository.UserIdentityRepository;
import com.softsuave.poc.request.model.Request;
import com.softsuave.poc.response.model.Response;
import com.softsuave.poc.utils.MDMUtils;

@Service
public class AndroidMdmServiceImpl implements AndroidMdmService {

	private static final Logger LOGGER = Logger.getLogger(AndroidMdmServiceImpl.class);

	private static final String COMPANY_ID_TOKEN = "getCompanyId";

	@Autowired
	MdmService mdmService;

	@Autowired
	CommandResultService commandResultService;

	@Autowired
	UserIdentityRepository userIdentityRepository;

	@Autowired
	UserCommandRepository userCommandRepository;

	@Autowired
	UserDeviceRepository userDeviceRepository;


	/***
	 * This method provides functionalities to validate user abTicket.
	 * 
	 */
	@Override
	public void validateTicket(String abTicket, String emailId) {

		try {
			Long userId = userIdentityRepository.userIdentityByEmailId(emailId);
			
			mdmService.validateAbTicket(abTicket, userId);

		} catch (AlertBootException e){
			throw e;
		} catch (Exception e){
			LOGGER.error("Exception while processing login process", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Error while processing. Please try again"));
		}

	}


	/***
	 * Register user device and sends back certificate number for further 
	 * communication.
	 * 
	 */
	@Override
	public Response registerDevice(String emailId) {

		Response response = new Response();

		Long userId = userIdentityRepository.userIdentityByEmailId(emailId);
		UserIdentity userIdentity = userIdentityRepository.userIdentityByUserId(userId);

		if (userIdentity == null) {
			response.setIdentity(mdmService.createIdentityCertificate(userId.toString()));
		} else
			response.setIdentity(userIdentity.getSerialNumber());

		return response;
	}


	/***
	 * Save android device details in DB.
	 * 
	 */
	@Override
	public void saveDevice(Request request) {

		UserIdentity userIdentity = mdmService.identifyUser(request.getIdentity());

		userDeviceRepository.saveDeviceDetails(request.getDeviceUdid(), "android", userIdentity.getUserId() , "",
				request.getDeviceToken(), "", request.getDeviceOwnerType());

	}


	/***
	 * This method process response from android device for last command and 
	 * will provide next command for device.
	 * 
	 */
	@Override
	public Response processTask(Request request) {

		LOGGER.info(request.toString());

		UserIdentity userIdentity = mdmService.identifyUser(request.getIdentity());

		String status = request.getStatus();
		String deviceUdid = request.getDeviceUdid();

		UserCommand userCommand = null;
		if (status.equals("Idle")) {

			userCommand = userCommandRepository.findNextCommand(userIdentity.getUserId(), deviceUdid);

		} else if(status.equals("Success")) {

			String commandUuid = request.getCommandUuid();
			userCommand = userCommandRepository.findByCommandUuid(userIdentity.getUserId(), commandUuid);
			processTaskResult(userCommand, request, userIdentity.getUserId());
			userCommand = userCommandRepository.updateCommandStatus(userIdentity.getUserId(), deviceUdid, commandUuid);

		} else if(status.equals("Error")) {

			String commandUuid = request.getCommandUuid();
			userCommand = userCommandRepository.updateCommandError(userIdentity.getUserId(), deviceUdid, commandUuid);
		}

		if(userCommand != null) {
			Response response = new Response();
			response.setCommand(userCommand.getCommand());
			response.setCommandType(userCommand.getCommandType());
			response.setCommandUuid(userCommand.getCommandUuid());
			return response;
		} else {
			return null;
		}
	}


	@Override
	public void unRegisterDevice(Request request) {

		UserIdentity userIdentity = mdmService.identifyUser(request.getIdentity());

		userDeviceRepository.removeDeviceDetails(request.getDeviceUdid(), "android", userIdentity.getUserId());

	}


	@Override
	public Response getCompanyId(String emailId, String token) {

		try {
			Long userId = userIdentityRepository.userIdentityByEmailId(emailId);

			String[] result = userIdentityRepository.userKeyByUserId(userId);

			if (result == null) {
				LOGGER.error("Login failed due to invalid userId");
				throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "Invalid user detail"));
			}

			String ticket = MDMUtils.decryptTicket(result[0], 
					(result[1] != null && !result[1].trim().isEmpty()) ? result[1].trim() : null, token);

			if (ticket.equalsIgnoreCase(COMPANY_ID_TOKEN)) {
				Response response = new Response();
				response.setCompanyGUID(userIdentityRepository.companyIdByUserId(userId));
				response.setUserId(userId);
				return response;
			} else {
				Response response = new Response();
				response.setCompanyGUID("");
				response.setUserId(userId);
				return response;
			}

		} catch (Exception e) {
			LOGGER.error("Exception while decrypting token", e);
			return null;
		}
	}


	private void processTaskResult(UserCommand userCommand, Request request, Long userId) {

		switch (userCommand.getCommandType()) {
		case "APPLICATION_LIST":
			commandResultService.saveApplicationList(userCommand, request.getPayload(), userId);
			break;
		case "DEVICE_INFO":
			commandResultService.saveDeviceInfo(userCommand, request.getPayload(), userId);
			break;
		case "DEVICE_LOCATION":
			commandResultService.saveDeviceLocation(userCommand, request.getPayload(), userId);
			break;
		default:
			LOGGER.info("Invalid commandType");
		}
	}
}
