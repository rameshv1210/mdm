package com.softsuave.demo.repository;

import com.softsuave.demo.model.MdmPolicy;

public interface MdmPolicyRepository {

	MdmPolicy getPolicy(Long userId, String companyId);

}
