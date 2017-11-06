package com.softsuave.demo.repository;

import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.ParameterMode;
import javax.persistence.PersistenceContext;
import javax.persistence.StoredProcedureQuery;

import org.springframework.stereotype.Repository;

import com.softsuave.demo.model.MdmPolicy;

@Repository
public class MdmPolicyRepositoryImpl implements MdmPolicyRepository {

	@PersistenceContext
	private EntityManager em;

	@Override
	public MdmPolicy getPolicy(Long userId, String companyId) {

		StoredProcedureQuery storedProcedure = em.createStoredProcedureQuery("getPolicy");

		storedProcedure.registerStoredProcedureParameter("userIdIn", Long.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("mdmPolicyTable", String.class, ParameterMode.IN);
		storedProcedure.registerStoredProcedureParameter("groupTable", String.class, ParameterMode.IN);
		storedProcedure.setParameter("userIdIn", userId);
		storedProcedure.setParameter("mdmPolicyTable", "global_policy.mdmpolicy" + companyId);
		storedProcedure.setParameter("groupTable", "global_policy.group" + companyId);

		boolean isResultset = storedProcedure.execute();
		if (isResultset) {
			List<MdmPolicy> mdmPolicys = processResultSet(storedProcedure);
			return mdmPolicys.size() > 0 ? mdmPolicys.get(0) : null;
		}

		return null;
	}

	@SuppressWarnings("rawtypes")
	private List<MdmPolicy> processResultSet(StoredProcedureQuery storedProcedure){
		Iterator resultList = storedProcedure.getResultList().iterator();
		List<MdmPolicy> mdmPolicys = new ArrayList<MdmPolicy>();
		while (resultList.hasNext()) {
			Object[] resultObject = (Object[]) resultList.next();
			MdmPolicy mdmPolicy = new MdmPolicy((Integer) resultObject[0],
					(String) resultObject[1], (String) resultObject[2],
					(String) resultObject[3], (String) resultObject[4],
					(Boolean) resultObject[5], (Timestamp) resultObject[6]);
			mdmPolicys.add(mdmPolicy);
		}
		return mdmPolicys;
	}
}
