package com.softsuave.demo.model;


public class UserIdentity {

	private Long userId;

	private String identityCert;

	private String serialNumber;

	public UserIdentity() {
	}

	public UserIdentity(Long userId, String identityCert, String serialNumber) {
		this.userId = userId;
		this.identityCert = identityCert;
		this.serialNumber = serialNumber;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getIdentityCert() {
		return identityCert;
	}

	public void setIdentityCert(String identityCert) {
		this.identityCert = identityCert;
	}

	public String getSerialNumber() {
		return serialNumber;
	}

	public void setSerialNumber(String serialNumber) {
		this.serialNumber = serialNumber;
	}

}
