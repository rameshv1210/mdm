package com.softsuave.poc.repository;

import com.softsuave.poc.model.UserCommand;

public interface UserCommandRepository {

	UserCommand findNextCommand(Long userId, String deviceUuid);

	UserCommand updateCommandStatus(Long userId, String deviceUuid, String commandUuid);

	UserCommand updateCommandError(Long userId, String deviceUuid, String commandUuid);

	UserCommand savedeviceCommand(String companyId, String groupId,
			Long userId, String deviceUuid, String deviceType,
			String commandType, String command, String commandUuid);

	UserCommand updatePushTime(String companyId, String groupId,
			Long userId, String deviceUuid, String deviceType);

	UserCommand findByCommandUuid(Long userId, String commandUuid);

}
