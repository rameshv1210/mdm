package com.softsuave.poc.model;

public class UserDevice {

	private Long id;

	private String deviceUUID;

	private String deviceType;

	private Long userId;

	private String devicePushMagic;

	private String deviceToken;

	private String unlockToken;

	private String deviceOwnerType;
	
	private Boolean isDeleted;
	
	private Boolean isDeleteRequested;

	public UserDevice(Long id, String deviceUUID, String deviceType,
			Long userId, String devicePushMagic, String deviceToken,
			String unlockToken, String deviceOwnerType, Boolean isDeleted,
			Boolean isDeleteRequested) {
		this.id = id;
		this.deviceUUID = deviceUUID;
		this.deviceType = deviceType;
		this.userId = userId;
		this.devicePushMagic = devicePushMagic;
		this.deviceToken = deviceToken;
		this.unlockToken = unlockToken;
		this.deviceOwnerType = deviceOwnerType;
		this.isDeleted = isDeleted;
		this.isDeleteRequested = isDeleteRequested;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

	public String getDeviceUUID() {
		return deviceUUID;
	}

	public void setDeviceUUID(String deviceUUID) {
		this.deviceUUID = deviceUUID;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getDevicePushMagic() {
		return devicePushMagic;
	}

	public void setDevicePushMagic(String devicePushMagic) {
		this.devicePushMagic = devicePushMagic;
	}

	public String getDeviceToken() {
		return deviceToken;
	}

	public void setDeviceToken(String deviceToken) {
		this.deviceToken = deviceToken;
	}

	public String getUnlockToken() {
		return unlockToken;
	}

	public void setUnlockToken(String unlockToken) {
		this.unlockToken = unlockToken;
	}

	public String getDeviceOwnerType() {
		return deviceOwnerType;
	}

	public void setDeviceOwnerType(String deviceOwnerType) {
		this.deviceOwnerType = deviceOwnerType;
	}

	public Boolean getIsDeleted() {
		return isDeleted;
	}

	public void setIsDeleted(Boolean isDeleted) {
		this.isDeleted = isDeleted;
	}

	public Boolean getIsDeleteRequested() {
		return isDeleteRequested;
	}

	public void setIsDeleteRequested(Boolean isDeleteRequested) {
		this.isDeleteRequested = isDeleteRequested;
	}

}