package com.softsuave.poc.repository;

import com.softsuave.poc.model.MdmPolicy;

public interface MdmPolicyRepository {

	MdmPolicy getPolicy(Long userId, String companyId);

}
