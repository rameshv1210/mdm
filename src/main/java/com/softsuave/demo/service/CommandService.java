package com.softsuave.demo.service;

import com.softsuave.demo.model.UserCommand;

public interface CommandService {

	String installProfile(Long userId, String companyId, UserCommand commandUUID);

	String generateCommandWithoutPayload(String fileName, UserCommand userCommand);

	String generateCommandWithPayload(String fileName, UserCommand userCommand);

	String generateCommandWithPayload(String fileName, UserCommand userCommand, String unlockToken);

}
