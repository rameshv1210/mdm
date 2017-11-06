package com.softsuave.poc.repository;

import java.util.List;

public interface IosCommandResultRepository {

	void saveIosProfileList(Long userId, String deviceUuid, int count,
			String payloadIdentifier, String payloadOrganization,
			String payloadVersion, String payloadDescription);

	void saveIosProvisioningProfileList(Long userId, String deviceUuid, int count,
			String name, String uuid, String expiryDate);

	void saveIosCertificateList(Long userId, String deviceUuid, int count,
			String commonName, String data, String isIdentity);

	void saveIosInstalledApplicationList(Long userId, String deviceUuid,
			int count, String bundleSize, String dynamicSize, String identifier,
			String isValidated, String name, String version);

	void saveIosSecurityInfo(Long userId, String deviceUuid,
			int hardwareEncryptionCaps, String passcodeCompliant,
			String passcodeCompliantWithProfiles, int passcodeLockGracePeriod,
			int passcodeLockGracePeriodEnforced, String passcodePresent);

	void saveIosDeviceInformation(Long userId, String deviceUuid, String deviceInfo);
	
	List<Object[]> getDeviceCommand(Long userId, String deviceUuid, String deviceType);

}
