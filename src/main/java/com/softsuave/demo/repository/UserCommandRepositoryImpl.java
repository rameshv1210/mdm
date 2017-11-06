package com.softsuave.demo.repository;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.apache.log4j.Logger;
import org.springframework.stereotype.Repository;

import com.softsuave.demo.model.UserCommand;

@Repository
public class UserCommandRepositoryImpl implements UserCommandRepository {

	@PersistenceContext
	private EntityManager em;
	
	private static final Logger LOGGER = Logger.getLogger(UserCommandRepositoryImpl.class);

	@Override
	public UserCommand findNextCommand(Long userId, String deviceUuid) {
		
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findNextCommand");
		
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		
		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<UserCommand> userCommands = processResultSet(storedProcedure);
			return userCommands.size() > 0 ? userCommands.get(0) : null;
		}
		
		return null;
	}

	@Override
	public UserCommand updateCommandStatus(Long userId, String deviceUuid, String commandUuid) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("updateCommandStatus");
		return updateCommand(storedProcedure, userId, deviceUuid, commandUuid);
	}

	@Override
	public UserCommand updateCommandError(Long userId, String deviceUuid, String commandUuid) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("updateCommandError");
		return updateCommand(storedProcedure, userId, deviceUuid, commandUuid);
	}

	private UserCommand updateCommand(StoredProcedureQuery storedProcedure, Long userId, String deviceUuid, String commandUuid){
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("commandUuid", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUuid", deviceUuid);
		storedProcedure.setParameter("commandUuid", commandUuid);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<UserCommand> userCommands = processResultSet(storedProcedure);
			return userCommands.size() > 0 ? userCommands.get(0) : null;
		}

		return null;
	}

	@Override
	public UserCommand findByCommandUuid(Long userId, String commandUuid) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("findByCommandUuid");

		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("commandUuid", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("commandUuid", commandUuid);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<UserCommand> userCommands = processResultSet(storedProcedure);
			return userCommands.size() > 0 ? userCommands.get(0) : null;
		}

		return null;
	}

	@Override
	public UserCommand savedeviceCommand(String companyId, String groupId,
			Long userId, String deviceUdid, String deviceType,
			String commandType, String command, String commandUuid) {
		
		LOGGER.info("Save Device Command: User Id:" + userId + " Company ID:" + companyId + " Group ID:" + groupId
				+ " CommandType:" + commandType + " Command ID:" + commandUuid +" Device uid:"+deviceUdid+" Device type: "+deviceType+"\nCommand:" +command);
		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("saveDeviceCommand");

		storedProcedure.registerStoredProcedureParameter("companyId", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("groupId", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("userId", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceUdid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("deviceType", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("commandType", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("commandUuid", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("command", String.class, ParameterMode.IN);
		storedProcedure.setParameter("companyId", companyId);
		storedProcedure.setParameter("groupId", groupId);
		storedProcedure.setParameter("userId", userId);
		storedProcedure.setParameter("deviceUdid", deviceUdid);
		storedProcedure.setParameter("deviceType", deviceType);
		storedProcedure.setParameter("commandType", commandType);
		storedProcedure.setParameter("commandUuid", commandUuid);
		storedProcedure.setParameter("command", command);

		storedProcedure.execute();

		return null;
	}

	@Override
	public UserCommand updatePushTime(String companyId, String groupId,
			Long userId, String deviceUuid, String deviceType) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("updatePushTime");

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

		storedProcedure.execute();
		
		return null;
	}

	@SuppressWarnings("rawtypes")
	private List<UserCommand> processResultSet(StoredProcedureQuery storedProcedure){
		Iterator resultList = storedProcedure.getResultList().iterator();
		List<UserCommand> userCommands = new ArrayList<UserCommand>();
		while (resultList.hasNext()) {
			Object[] resultObject = (Object[]) resultList.next();
			UserCommand userCommand = new UserCommand(
					((BigInteger) resultObject[0]).longValue(),
					(String) resultObject[1], (String) resultObject[2],
					(String) resultObject[3], (String) resultObject[4],
					(String) resultObject[5], (Timestamp) resultObject[6],
					(Timestamp) resultObject[7], (Boolean) resultObject[8]);
			userCommands.add(userCommand);
		}
		return userCommands;
	}
}
