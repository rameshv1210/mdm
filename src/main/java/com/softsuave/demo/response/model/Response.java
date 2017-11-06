package com.softsuave.demo.response.model;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(Include.NON_NULL)
public class Response {

	private String identity;
	private String command;
	private String commandType;
	private String commandUuid;
	private String companyGUID;
	private Long userId;

	public String getIdentity() {
		return identity;
	}

	public void setIdentity(String identity) {
		this.identity = identity;
	}

	public String getCommand() {
		return command;
	}

	public void setCommand(String command) {
		this.command = command;
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

	public String getCompanyGUID() {
		return companyGUID;
	}

	public void setCompanyGUID(String companyGUID) {
		this.companyGUID = companyGUID;
	}

	public Long getUserId() {
		return userId;
	}

	public void setUserId(Long userId) {
		this.userId = userId;
	}

}
