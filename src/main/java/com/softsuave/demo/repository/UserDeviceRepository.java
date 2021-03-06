package com.softsuave.demo.repository;

import java.util.List;

import com.softsuave.demo.model.UserDevice;

public interface UserDeviceRepository {

	List<UserDevice> findUserDevice(String companyId, String groupId,
			Long userId, String deviceUuid, String deviceType);

	void saveDeviceDetails(String deviceUUID, String deviceType, Long userId,
			String devicePushMagic, String deviceToken, String unlockToken,
			String deviceOwnerType);

	void removeDeviceDetails(String deviceUUID, String deviceType, Long userId);
}
