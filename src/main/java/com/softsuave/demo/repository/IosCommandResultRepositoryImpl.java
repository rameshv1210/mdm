package com.softsuave.demo.repository;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.springframework.stereotype.Repository;

@Repository
public class IosCommandResultRepositoryImpl implements IosCommandResultRepository {

	@PersistenceContext
	private EntityManager em;

	@Override
	public void saveIosProfileList(Long userId, String deviceUuid,
			int count, String payloadIdentifier, String payloadOrganization,
			String payloadVersion, String payloadDescription) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosProfileList");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("profileCount", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("payloadIdentifier", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("payloadOrganization", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("payloadVersion", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("payloadDescription", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("profileCount", count);
		storedProcedure.setParameter("payloadIdentifier", payloadIdentifier);
		storedProcedure.setParameter("payloadOrganization", payloadOrganization);
		storedProcedure.setParameter("payloadVersion", payloadVersion);
		storedProcedure.setParameter("payloadDescription", payloadDescription);

		storedProcedure.execute();
	}

	@Override
	public void saveIosProvisioningProfileList(Long userId, String deviceUuid,
			int count, String name, String uuid, String expiryDate) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosProvisioningProfileList");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("profileCount", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("uuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("expiryDate", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("profileCount", count);
		storedProcedure.setParameter("name", name);
		storedProcedure.setParameter("uuid", uuid);
		storedProcedure.setParameter("expiryDate", expiryDate);

		storedProcedure.execute();
	}

	@Override
	public void saveIosCertificateList(Long userId, String deviceUuid, int count,
			String commonName, String data, String isIdentity) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosCertificateList");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("profileCount", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("commonName", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("certData", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("isIdentity", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("profileCount", count);
		storedProcedure.setParameter("commonName", commonName);
		storedProcedure.setParameter("certData", data);
		storedProcedure.setParameter("isIdentity", isIdentity);

		storedProcedure.execute();
	}

	@Override
	public void saveIosInstalledApplicationList(Long userId, String deviceUuid,
			int count, String bundleSize, String dynamicSize, String identifier,
			String isValidated, String name, String version) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosInstalledApplicationList");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("profileCount", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("bundleSize", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("dynamicSize", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("identifier", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("isValidated", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("version", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("profileCount", count);
		storedProcedure.setParameter("bundleSize", bundleSize);
		storedProcedure.setParameter("dynamicSize", dynamicSize);
		storedProcedure.setParameter("identifier", identifier);
		storedProcedure.setParameter("isValidated", isValidated);
		storedProcedure.setParameter("name", name);
		storedProcedure.setParameter("version", version);

		storedProcedure.execute();
	}

	@Override
	public void saveIosSecurityInfo(Long userId, String deviceUuid,
			int hardwareEncryptionCaps, String passcodeCompliant,
			String passcodeCompliantWithProfiles, int passcodeLockGracePeriod,
			int passcodeLockGracePeriodEnforced, String passcodePresent) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosSecurityInfo");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("hardwareEncryptionCaps", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("passcodeCompliant", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("passcodeCompliantWithProfiles", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("passcodeLockGracePeriod", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("passcodeLockGracePeriodEnforced", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("passcodePresent", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("hardwareEncryptionCaps", hardwareEncryptionCaps);
		storedProcedure.setParameter("passcodeCompliant", passcodeCompliant);
		storedProcedure.setParameter("passcodeCompliantWithProfiles", passcodeCompliantWithProfiles);
		storedProcedure.setParameter("passcodeLockGracePeriod", passcodeLockGracePeriod);
		storedProcedure.setParameter("passcodeLockGracePeriodEnforced", passcodeLockGracePeriodEnforced);
		storedProcedure.setParameter("passcodePresent", passcodePresent);

		storedProcedure.execute();
	}

	@Override
	public void saveIosDeviceInformation(Long userId, String deviceUuid, String deviceInfo) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveIosDeviceInformation");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceInfo", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("deviceInfo", deviceInfo);

		storedProcedure.execute();
	}
	
	@Override
	public List<Object[]> getDeviceCommand(Long userId, String deviceUuid, String deviceType) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("getDeviceCommands");

		storedProcedure.registerStoredProcedureParameter("user_id", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("device_uuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("device_type", String.class, ParameterMode.IN);
		storedProcedure.setParameter("user_id", userId);
		storedProcedure.setParameter("device_uuid", deviceUuid);
		storedProcedure.setParameter("device_type", deviceType);

		return (List<Object[]>) storedProcedure.getResultList();
	}
}
