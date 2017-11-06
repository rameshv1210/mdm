package com.softsuave.demo.repository;

import com.softsuave.demo.model.UserIdentity;

public interface UserIdentityRepository {

	UserIdentity userIdentityBySerialNumber(String serialNumber);

	UserIdentity userIdentityByUserId(Long userId);

	String companyIdByUserId(Long userId);

	void saveUserIdentity(Long userId, String identityCert, String serialNumber);

	Long userIdentityByEmailId(String emailId);

	String[] userKeyByUserId(long userId);
}
