package com.softsuave.demo.model;

import java.sql.Timestamp;

public class UserCommand {

	private Long id;

	private String deviceUuid;

	private String deviceType;

	private String commandType;

	private String commandUuid;

	private String command;

	private Timestamp createdTimestamp;

	private Timestamp pushedTimestamp;

	private Boolean isAcknowledged;

	public UserCommand() {
	}

	public UserCommand(Long id, String deviceUuid, String deviceType,
			String commandType, String commandUuid, String command,
			Timestamp createdTimestamp, Timestamp pushedTimestamp,
			Boolean isAcknowledged) {
		this.id = id;
		this.deviceUuid = deviceUuid;
		this.deviceType = deviceType;
		this.commandType = commandType;
		this.commandUuid = commandUuid;
		this.command = command;
		this.createdTimestamp = createdTimestamp;
		this.pushedTimestamp = pushedTimestamp;
		this.isAcknowledged = isAcknowledged;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getDeviceUuid() {
		return deviceUuid;
	}

	public void setDeviceUuid(String deviceUuid) {
		this.deviceUuid = deviceUuid;
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

	public String getCommandUuid() {
		return commandUuid;
	}

	public void setCommandUuid(String commandUuid) {
		this.commandUuid = commandUuid;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
	}

	public Timestamp getCreatedTimestamp() {
		return createdTimestamp;
	}

	public void setCreatedTimestamp(Timestamp createdTimestamp) {
		this.createdTimestamp = createdTimestamp;
	}

	public Timestamp getPushedTimestamp() {
		return pushedTimestamp;
	}

	public void setPushedTimestamp(Timestamp pushedTimestamp) {
		this.pushedTimestamp = pushedTimestamp;
	}

	public Boolean getIsAcknowledged() {
		return isAcknowledged;
	}

	public void setIsAcknowledged(Boolean isAcknowledged) {
		this.isAcknowledged = isAcknowledged;
	}

}