package com.softsuave.demo.request.model;

public class Request {

	private String identity;
	private String deviceToken;
	private String deviceOwnerType;
	private String commandUuid;
	private String status;
	private String payload;

	private String companyId;
	private String groupId;
	private String userId;
	private String abTicket;
	private String deviceUdid;
	private String deviceType;
	private String commandType;
	private String command;

	public Request() {
	}

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public String getDeviceToken() {
		return deviceToken;
	}

	public void setDeviceToken(String deviceToken) {
		this.deviceToken = deviceToken;
	}

	public String getDeviceOwnerType() {
		return deviceOwnerType;
	}

	public void setDeviceOwnerType(String deviceOwnerType) {
		this.deviceOwnerType = deviceOwnerType;
	}

	public String getCommandUuid() {
		return commandUuid;
	}

	public void setCommandUuid(String commandUuid) {
		this.commandUuid = commandUuid;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getPayload() {
		return payload;
	}

	public void setPayload(String payload) {
		this.payload = payload;
	}

	public String getCompanyId() {
		return companyId;
	}

	public void setCompanyId(String companyId) {
		this.companyId = companyId;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getAbTicket() {
		return abTicket;
	}

	public void setAbTicket(String abTicket) {
		this.abTicket = abTicket;
	}

	public String getDeviceUdid() {
		return deviceUdid;
	}

	public void setDeviceUdid(String deviceUdid) {
		this.deviceUdid = deviceUdid;
	}

	public String getDeviceType() {
		return deviceType;
	}

	public void setDeviceType(String deviceType) {
		this.deviceType = deviceType;
	}

	public String getCommandType() {
		return commandType;
	}

	public void setCommandType(String commandType) {
		this.commandType = commandType;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	@Override
	public String toString() {
		return "{identity=" + identity + ", deviceToken=" + deviceToken
				+ ", commandUuid=" + commandUuid + ", status=" + status
				+ ", payload=" + payload + ", companyId=" + companyId
				+ ", groupId=" + groupId + ", userId=" + userId
				+ ", deviceUdid=" + deviceUdid + ", deviceType=" + deviceType
				+ ", commandType=" + commandType + ", command=" + command + "}";
	}

}
