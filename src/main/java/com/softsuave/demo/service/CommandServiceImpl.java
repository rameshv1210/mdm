package com.softsuave.demo.service;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Service;

import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.model.UserCommand;
import com.softsuave.demo.utils.MDMUtils;

@Service
public class CommandServiceImpl implements CommandService {

	private static final Logger LOGGER = Logger.getLogger(CommandServiceImpl.class);

	@Value("${certificate.path}")
	String certPath;

	@Value("${profile.path}")
	String profilePath;

	@Value("${policy.layout.path}")
	String policyLayoutPath;


	@Override
	public String installProfile(Long userId, String companyId, UserCommand userCommand) {
		try {
			String commandUUID = userCommand.getCommandUuid();
			String command = new String(Files.readAllBytes(Paths.get(policyLayoutPath + "install_profile.txt")));

			String profile = userCommand.getCommand();
			MDMUtils.createProfile(profilePath, commandUUID, profile);
			MDMUtils.signProfile(certPath, commandUUID);
			profile = Base64.getEncoder().encodeToString(
					Files.readAllBytes(Paths.get(profilePath + commandUUID + "_sign.mobileconfig")));

			command = command.replace("{payload_data}", profile);
			command = command.replace("{UUID}", commandUUID);

			MDMUtils.removeProfile(certPath, commandUUID);
			return command;
		} catch (IOException | InterruptedException e) {
			LOGGER.error("Exception while fetching profile for command", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while fetching profile for command"));
		}
	}


	@Override
	public String generateCommandWithoutPayload(String fileName, UserCommand userCommand) {
		try {

			String command = new String(Files.readAllBytes(Paths.get(policyLayoutPath + fileName)));

			command = command.replace("{commandType}", userCommand.getCommandType());
			command = command.replace("{UUID}", userCommand.getCommandUuid());

			return command;

		} catch (IOException e) {
			LOGGER.error("Exception while fetching layout for command", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while fetching profile for command"));
		}
	}


	@Override
	public String generateCommandWithPayload(String fileName, UserCommand userCommand, String unlockToken) {
		try {
			String command = new String(Files.readAllBytes(Paths.get(policyLayoutPath + fileName)));
			
			command = command.replace("{payload_data}", unlockToken);
			command = command.replace("{UUID}", userCommand.getCommandUuid());
			
			return command;
		} catch (IOException e) {
			LOGGER.error("Exception while fetching layout for command", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while fetching profile for command"));
		}
	}


	@Override
	public String generateCommandWithPayload(String fileName, UserCommand userCommand) {
		try {
			String command = new String(Files.readAllBytes(Paths.get(policyLayoutPath + fileName)));

			command = command.replace("{payload_data}", userCommand.getCommand());
			command = command.replace("{UUID}", userCommand.getCommandUuid());

			return command;
		} catch (IOException e) {
			LOGGER.error("Exception while fetching layout for command", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while fetching profile for command"));
		}
	}
}
