package com.softsuave.demo.repository;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Repository;

import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.model.UserIdentity;

@Repository
public class UserIdentityRepositoryImpl implements UserIdentityRepository {

	@PersistenceContext
	private EntityManager em;

	@Override
	public void saveUserIdentity(Long userId, String identityCert, String serialNumber) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveUserIdentity");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("identityCert", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("serialNumber", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("identityCert", identityCert);
		storedProcedure.setParameter("serialNumber", serialNumber);

		storedProcedure.execute();
	}

	@Override
	public UserIdentity userIdentityBySerialNumber(String serialNumber) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findUserIdentityBySerialNumber");

		storedProcedure.registerStoredProcedureParameter("serialNumber", String.class, ParameterMode.IN);
		storedProcedure.setParameter("serialNumber", serialNumber);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<UserIdentity> userIdentities = processResultSet(storedProcedure);
			return userIdentities.size() > 0 ? userIdentities.get(0) : null;
		}

		return null;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public Long userIdentityByEmailId(String emailId) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findUserIdByEmailId");
		
		storedProcedure.registerStoredProcedureParameter("emailId", String.class, ParameterMode.IN);
		storedProcedure.setParameter("emailId", emailId);
		
		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			Iterator resultList = storedProcedure.getResultList().iterator();
			while (resultList.hasNext()) {
				return ((BigInteger) resultList.next()).longValue();
			}
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.NOT_FOUND, "User not found"));
		} else {
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.NOT_FOUND, "User not found"));
		}
	}

	@Override
	public UserIdentity userIdentityByUserId(Long userId) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findUserIdentityByUserId");
		
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		
		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<UserIdentity> userIdentities = processResultSet(storedProcedure);
			return userIdentities.size() > 0 ? userIdentities.get(0) : null;
		}
		return null;
	}

	@SuppressWarnings("rawtypes")
	@Override
	public String companyIdByUserId(Long userId) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findCompanyIdByUserId");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			Iterator resultList = storedProcedure.getResultList().iterator();
			while (resultList.hasNext()) {
				Object resultObject = (Object) resultList.next();
				return (String)resultObject;
			}
		}

		return null;
	}


	@SuppressWarnings("rawtypes")
	@Override
	public String[] userKeyByUserId(long userId) {
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findUserKeyByUserId");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			Iterator resultList = storedProcedure.getResultList().iterator();
			while (resultList.hasNext()) {
				Object[] resultObject = (Object[]) resultList.next();
				String[] result = {(String) resultObject[0], (String) resultObject[1]};
				return result;
			}
		}

		return null;
	}


	@SuppressWarnings("rawtypes")
	private List<UserIdentity> processResultSet(StoredProcedureQuery storedProcedure){
		Iterator resultList = storedProcedure.getResultList().iterator();
		List<UserIdentity> userIdentities = new ArrayList<UserIdentity>();
		while (resultList.hasNext()) {
			Object[] resultObject = (Object[]) resultList.next();
			UserIdentity userIdentity = new UserIdentity(((BigInteger) resultObject[0]).longValue(),
					(String) resultObject[1], (String) resultObject[2]);
			userIdentities.add(userIdentity);
		}
		return userIdentities;
	}

}
