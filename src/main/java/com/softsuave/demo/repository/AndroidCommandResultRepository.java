package com.softsuave.demo.repository;

public interface AndroidCommandResultRepository {

	void saveAndroidApplicationList(Long userId, String deviceUuid, int count,
			String isActive, String packageApi, String uss, String isSystemApp,
			String version, String name);

	void saveAndroidDeviceInfo(Long userId, String deviceUuid, String deviceInfo);

	void saveAndroidDeviceLocation(Long userId, String deviceUuid, 
			String longitude, String latitude);

}
