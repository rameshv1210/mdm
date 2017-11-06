package com.softsuave.demo.service;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.text.ParseException;

import javax.xml.parsers.ParserConfigurationException;

import org.apache.commons.codec.binary.Hex;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;
import org.xml.sax.SAXException;

import com.dd.plist.NSArray;
import com.dd.plist.NSData;
import com.dd.plist.NSDictionary;
import com.dd.plist.PropertyListFormatException;
import com.dd.plist.PropertyListParser;
import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.model.UserCommand;
import com.softsuave.demo.model.UserDevice;
import com.softsuave.demo.repository.UserCommandRepository;
import com.softsuave.demo.repository.UserDeviceRepository;
import com.softsuave.demo.repository.UserIdentityRepository;

@Service
public class IOSMdmHelperServiceImpl implements IOSMdmHelperService {

	private static final Logger LOGGER = Logger.getLogger(IOSMdmHelperServiceImpl.class);

	@Autowired
	CommandService commandService;

	@Autowired
	CommandResultService commandResultService;

	@Autowired
	UserIdentityRepository userIdentityRepository;

	@Autowired
	UserDeviceRepository userDeviceRepository;

	@Autowired
	UserCommandRepository userCommandRepository;

	/***
	 * This method convert input request from device to NSDictionary object
	 * 
	 */
	@Override
	public NSDictionary parseRequestToPlist(String request) {
		NSDictionary dictionary;
		try {
			dictionary = (NSDictionary) PropertyListParser.parse(new ByteArrayInputStream(request.getBytes()));
		} catch (IOException | PropertyListFormatException | ParseException | ParserConfigurationException
				| SAXException e) {
			LOGGER.error("Exception while parsing the request", e);
			throw new AlertBootException(
					new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while parsing the request"));
		}
		return dictionary;
	}

	/***
	 * This service method handle checkIn request from device.
	 * 
	 */
	@Override
	public void processDeviceMessage(NSDictionary dictionary, Long userId) {

		String messageType = dictionary.objectForKey("MessageType").toString();

		if (messageType.equals("Authenticate")) {

			return;

		} else if (messageType.equals("TokenUpdate")) {

			String udid = dictionary.objectForKey("UDID").toString();
			NSData tokenData = ((NSData) dictionary.objectForKey("Token"));
			String PushMagic = dictionary.objectForKey("PushMagic").toString();
			NSData unlockTokenData = (NSData) dictionary.objectForKey("UnlockToken");

			userDeviceRepository.saveDeviceDetails(udid, "ios", userId, PushMagic,
					new String(Hex.encodeHex(tokenData.bytes())), unlockTokenData.getBase64EncodedData(), "");
			return;

		} else if (messageType.equals("CheckOut")) {

			String udid = dictionary.objectForKey("UDID").toString();
			userDeviceRepository.removeDeviceDetails(udid, "ios", userId);
			return;

		} else {

			LOGGER.error("Unknown messageType send by client");
			throw new AlertBootException(
					new AlertBootErrorMessage(HttpStatus.BAD_REQUEST, "Unknown messageType send by client"));

		}
	}

	/***
	 * This method process response from ios device for last command and will
	 * provide next command for device.
	 * 
	 */
	@Override
	public byte[] processDeviceRequest(NSDictionary dictionary, Long userId) {

		String status = dictionary.objectForKey("Status").toString();
		String udid = dictionary.objectForKey("UDID").toString();

		UserCommand userCommand = null;
		if (status.equals("Idle")) {
			LOGGER.info("iOS device in idle state");
			userCommand = userCommandRepository.findNextCommand(userId, udid);

		} else if (status.equals("Acknowledged")) {

			String commandUuid = dictionary.objectForKey("CommandUUID").toString();
			userCommand = userCommandRepository.findByCommandUuid(userId, commandUuid);
			processCommandResult(userCommand, dictionary, userId);
			userCommand = userCommandRepository.updateCommandStatus(userId, udid, commandUuid);

		} else if (status.equals("CommandFormatError") || status.equals("Error")) {

			String commandUuid = dictionary.objectForKey("CommandUUID").toString();
			userCommand = userCommandRepository.updateCommandError(userId, udid, commandUuid);
		}

		if (userCommand != null) {
			String command = processCommand(userCommand, userId, userIdentityRepository.companyIdByUserId(userId), udid,
					userCommand.getCommandUuid());
			return command.getBytes();
		} else {
			return null;
		}

	}

	/***
	 * Formats command before sending to client based on it's type.
	 * 
	 * @param userCommand
	 * @param userId
	 * @param companyId
	 * @param commandUUId 
	 * @param udid 
	 * @return
	 */
	private String processCommand(UserCommand userCommand, Long userId, String companyId, String udid, String commandUUId) {

		switch (userCommand.getCommandType()) {
		case "InstallProfile":
			return commandService.installProfile(userId, companyId, userCommand);

		case "ProfileList":
		case "ProvisioningProfileList":
		case "CertificateList":
		case "InstalledApplicationList":
		case "SecurityInfo":
		case "EraseDevice":
			return commandService.generateCommandWithoutPayload("general_command.txt", userCommand);

		case "DeviceInformation":
			return commandService.generateCommandWithoutPayload("device_info.txt", userCommand);

		case "Restrictions":
			return commandService.generateCommandWithoutPayload("restrictions.txt", userCommand);

		case "RemoveProfile":
			return commandService.generateCommandWithPayload("remove_profile.txt", userCommand);

		case "InstallProvisioningProfile":
			return commandService.generateCommandWithPayload("install_provisioning_profile.txt", userCommand);

		case "RemoveProvisioningProfile":
			return commandService.generateCommandWithPayload("remove_provisioning_profile.txt", userCommand);

		case "DeviceLock":
			return commandService.generateCommandWithPayload("device_lock.txt", userCommand);

		case "ClearPasscode":
			UserDevice userDevice = userDeviceRepository
					.findUserDevice("", "", userId, userCommand.getDeviceUuid(), userCommand.getDeviceType()).get(0);
			return commandService.generateCommandWithPayload("clear_passcode.txt", userCommand,
					userDevice.getUnlockToken());

		case "Settings":
			return commandService.generateCommandWithPayload("settings.txt", userCommand);

		default:
			LOGGER.error("Invalid commandType");
			userCommandRepository.updateCommandError(userId, udid, commandUUId);
			throw new AlertBootException(
					new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Invalid commandType"));
		}
	}

	/***
	 * Process command response from device and stores it in database.
	 * 
	 * @param userCommand
	 * @param dictionary
	 * @param userId
	 */
	private void processCommandResult(UserCommand userCommand, NSDictionary dictionary, Long userId) {

		switch (userCommand.getCommandType()) {
		case "ProfileList":
			commandResultService.saveProfileList(userCommand,
					(NSArray) dictionary.objectForKey(userCommand.getCommandType()), userId);
			break;
		case "ProvisioningProfileList":
			commandResultService.saveProvisioningProfileList(userCommand,
					(NSArray) dictionary.objectForKey(userCommand.getCommandType()), userId);
			break;
		case "CertificateList":
			commandResultService.saveCertificateList(userCommand,
					(NSArray) dictionary.objectForKey(userCommand.getCommandType()), userId);
			break;
		case "InstalledApplicationList":
			commandResultService.saveInstalledApplicationList(userCommand,
					(NSArray) dictionary.objectForKey(userCommand.getCommandType()), userId);
			break;
		case "SecurityInfo":
			commandResultService.saveSecurityInfo(userCommand,
					(NSDictionary) dictionary.objectForKey(userCommand.getCommandType()), userId);
			break;
		case "DeviceInformation":
			commandResultService.saveDeviceInformation(userCommand,
					(NSDictionary) dictionary.objectForKey("QueryResponses"), userId);
			break;
		default:
			LOGGER.info("Invalid commandType");
		}
	}
}