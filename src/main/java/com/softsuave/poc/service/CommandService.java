package com.softsuave.poc.service;

import com.softsuave.poc.model.UserCommand;

public interface CommandService {

	String installProfile(Long userId, String companyId, UserCommand commandUUID);

	String generateCommandWithoutPayload(String fileName, UserCommand userCommand);

	String generateCommandWithPayload(String fileName, UserCommand userCommand);

	String generateCommandWithPayload(String fileName, UserCommand userCommand, String unlockToken);

}
