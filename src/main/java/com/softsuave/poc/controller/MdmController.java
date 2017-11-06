package com.softsuave.poc.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.softsuave.poc.exception.AlertBootErrorMessage;
import com.softsuave.poc.exception.AlertBootException;
import com.softsuave.poc.request.model.Request;
import com.softsuave.poc.service.MdmService;

@RestController
public class MdmController {

	@Autowired
	MdmService mdmService;


	/***
	 * API to send push notification.
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/push", method = RequestMethod.POST)
	private void push(@RequestBody Request request) {

		validatePushRequest(request);

		mdmService.sendPush(request);

	}


	/***
	 * API to receive device command.
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/device/command", method = RequestMethod.POST)
	private void deviceCommand(HttpServletRequest requestBody) {

		Request request = parseRequest(requestBody);
		validateCommandRequest(request);
		validateCommand(request);
		mdmService.receiveDeviceCommand(request);

	}


	/***
	 * API to receive device command and execute it.
	 * 
	 * @param request
	 */
	@RequestMapping(value = "/device/execute", method = RequestMethod.POST)
	private void deviceCommandExecute(HttpServletRequest requestBody) {

		Request request = parseRequest(requestBody);
		validateCommandRequest(request);
		validateCommand(request);
		mdmService.executeDeviceCommand(request);

	}


	private Request parseRequest(HttpServletRequest request) {

		Request requestModel = new Request();

		requestModel.setCompanyId(request.getParameter("companyId") == null ? "" : request.getParameter("companyId"));
		requestModel.setGroupId(request.getParameter("groupId") == null ? "" : request.getParameter("groupId"));
		requestModel.setUserId(request.getParameter("userId") == null ? "" : request.getParameter("userId"));
		requestModel.setDeviceType(request.getParameter("deviceType") == null ? "" : request.getParameter("deviceType"));
		requestModel.setDeviceUdid(request.getParameter("deviceUdid") == null ? "" : request.getParameter("deviceUdid"));
		requestModel.setCommandType(request.getParameter("commandType") == null ? "" : request.getParameter("commandType"));
		requestModel.setCommand(request.getParameter("command") == null ? "" : request.getParameter("command"));

		return requestModel;
	}


	private void validatePushRequest(Request request){

		if (request.getDeviceType() == null || request.getDeviceType().trim().isEmpty())
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "deviceType is mandatory"));

		if ((request.getCompanyId() == null || request.getCompanyId().trim().isEmpty())
				&& (request.getUserId() == null || request.getUserId().trim().isEmpty()))
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "companyId or userId is needed"));

		if ((request.getGroupId() != null && !request.getGroupId().trim().isEmpty())
				&& (request.getDeviceUdid() != null && !request.getDeviceUdid().trim().isEmpty()))
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "groupId and deviceUdid combination not accepted"));
	}


	private void validateCommandRequest(Request request){

		if (request.getCommand() == null || request.getCommand().trim().isEmpty())
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "command is mandatory"));

		if (request.getCommandType() == null || request.getCommandType().trim().isEmpty())
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "commandType is mandatory"));

		if (request.getDeviceType() == null || request.getDeviceType().trim().isEmpty())
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "deviceType is mandatory"));

		if ((request.getCompanyId() == null || request.getCompanyId().trim().isEmpty())
				&& (request.getUserId() == null || request.getUserId().trim().isEmpty()))
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "companyId or userId is needed"));

		if ((request.getGroupId() != null && !request.getGroupId().trim().isEmpty())
				&& (request.getDeviceUdid() != null && !request.getDeviceUdid().trim().isEmpty()))
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "groupId and deviceUdid combination not accepted"));
	}


	private void validateCommand(Request request) {
		if ((request.getCommandType().equalsIgnoreCase("DeviceLock")
				|| request.getCommandType().equalsIgnoreCase("ClearPasscode")
				|| request.getCommandType().equalsIgnoreCase("EraseDevice")
				|| request.getCommandType().equalsIgnoreCase("ENTERPRISE_WIPE")
				|| request.getCommandType().equalsIgnoreCase("DISENROLL")
				|| request.getCommandType().equalsIgnoreCase("DEVICE_LOCK")
				|| request.getCommandType().equalsIgnoreCase("CHANGE_LOCK_CODE")
				|| request.getCommandType().equalsIgnoreCase("CLEAR_PASSWORD")
				|| (request.getCommandType().equalsIgnoreCase("InstallProfile") 
						&& (request.getCommand().contains("ENTERPRISE_WIPE")
								|| request.getCommand().contains("DISENROLL")
								|| request.getCommand().contains("DEVICE_LOCK")
								|| request.getCommand().contains("CLEAR_PASSWORD")
								|| request.getCommand().contains("CHANGE_LOCK_CODE")))) && 
				(request.getDeviceUdid() == null || request.getDeviceUdid().trim().isEmpty())) {

			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.FORBIDDEN,
							"Restriction for this command to apply for more than a device"));
		}

		if (request.getCommandType().equalsIgnoreCase("UPDATE_APK") && 
				!request.getDeviceType().equalsIgnoreCase("Android")) {

			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.FORBIDDEN,
							"This command should be applied only for Android device"));
		}
	}
}
