package com.softsuave.poc.repository;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.springframework.stereotype.Repository;

import com.softsuave.poc.model.UserDevice;

@Repository
public class UserDeviceRepositoryImpl implements UserDeviceRepository {

	@PersistenceContext
	private EntityManager em;
	
	@Override
	public void saveDeviceDetails(String deviceUUID, String deviceType,
			Long userId, String devicePushMagic, String deviceToken,
			String unlockToken, String deviceOwnerType) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveDeviceDetails");
		
		storedProcedure.registerStoredProcedureParameter("deviceUUID", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceType", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("devicePushMagic", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceToken", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("unlockToken", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceOwnerType", String.class, ParameterMode.IN);
		
		storedProcedure.setParameter("deviceUUID", deviceUUID);
		storedProcedure.setParameter("deviceType", deviceType);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("devicePushMagic", devicePushMagic);
		storedProcedure.setParameter("deviceToken", deviceToken);
		storedProcedure.setParameter("unlockToken", unlockToken);
		storedProcedure.setParameter("deviceOwnerType", deviceOwnerType);
		
		storedProcedure.execute();
	}

	@Override
	public void removeDeviceDetails(String deviceUUID, String deviceType, Long userId) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("removeDeviceDetails");

		storedProcedure.registerStoredProcedureParameter("deviceUUID", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceType", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);

		storedProcedure.setParameter("deviceUUID", deviceUUID);
		storedProcedure.setParameter("deviceType", deviceType);
		storedProcedure.setParameter("userId", userId);

		storedProcedure.execute();
	}

	@SuppressWarnings("rawtypes")
	@Override
	public List<UserDevice> findUserDevice(String companyId, String groupId,
			Long userId, String deviceUuid, String deviceType) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findUserDevice");

		storedProcedure.registerStoredProcedureParameter("companyId", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("groupId", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceType", String.class, ParameterMode.IN);
		storedProcedure.setParameter("companyId", companyId);
		storedProcedure.setParameter("groupId", groupId);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("deviceType", deviceType);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			Iterator resultList = storedProcedure.getResultList().iterator();
			List<UserDevice> userDevices = new ArrayList<UserDevice>();
			while (resultList.hasNext()) {
				Object[] resultObject = (Object[]) resultList.next();
				UserDevice userDevice = new UserDevice(((BigInteger) resultObject[0]).longValue(),
						(String) resultObject[1], (String) resultObject[2], ((BigInteger) resultObject[3]).longValue(),
						(String) resultObject[4], (String) resultObject[5],
						(String) resultObject[6], (String) resultObject[7], 
						(Boolean) resultObject[8], (Boolean) resultObject[9]);
				userDevices.add(userDevice);
			}
			return userDevices;
		}

		return null;
	}

}
