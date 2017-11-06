package com.softsuave.demo.repository;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.springframework.stereotype.Repository;

@Repository
public class AndroidCommandResultRepositoryImpl implements AndroidCommandResultRepository {

	@PersistenceContext
	private EntityManager em;


	@Override
	public void saveAndroidApplicationList(Long userId, String deviceUuid, int count,
			String isActive, String packageApi, String uss, String isSystemApp,
			String version, String name) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveAndroidApplicationList");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("appCount", Integer.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("isActive", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("packageApi", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("uss", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("isSystemApp", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("version", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("name", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("appCount", count);
		storedProcedure.setParameter("isActive", isActive);
		storedProcedure.setParameter("packageApi", packageApi);
		storedProcedure.setParameter("uss", uss);
		storedProcedure.setParameter("isSystemApp", isSystemApp);
		storedProcedure.setParameter("version", version);
		storedProcedure.setParameter("name", name);

		storedProcedure.execute();
	}

	@Override
	public void saveAndroidDeviceInfo(Long userId, String deviceUuid, String deviceInfo) {
		
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveAndroidDeviceInfo");
		
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceInfo", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("deviceInfo", deviceInfo);
		
		storedProcedure.execute();
	}

	@Override
	public void saveAndroidDeviceLocation(Long userId, String deviceUuid, 
			String longitude, String latitude) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveAndroidDeviceLocation");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("longitude", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("latitude", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("longitude", longitude);
		storedProcedure.setParameter("latitude", latitude);

		storedProcedure.execute();
	}
}
