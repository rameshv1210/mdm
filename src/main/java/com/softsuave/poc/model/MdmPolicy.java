package com.softsuave.poc.model;

import java.sql.Timestamp;

public class MdmPolicy {

	private Integer id;
	private String policyName;
	private String description;
	private String androidJson;
	private String iosJson;
	private Boolean defaultPolicy;
	private Timestamp updateDateTime;

	public MdmPolicy() {
	}

	public MdmPolicy(Integer id, String policyName, String description,
			String androidJson, String iosJson, Boolean defaultPolicy,
			Timestamp updateDateTime) {
		this.id = id;
		this.policyName = policyName;
		this.description = description;
		this.androidJson = androidJson;
		this.iosJson = iosJson;
		this.defaultPolicy = defaultPolicy;
		this.updateDateTime = updateDateTime;
	}

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	public String getPolicyName() {
		return policyName;
	}

	public void setPolicyName(String policyName) {
		this.policyName = policyName;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getAndroidJson() {
		return androidJson;
	}

	public void setAndroidJson(String androidJson) {
		this.androidJson = androidJson;
	}

	public String getIosJson() {
		return iosJson;
	}

	public void setIosJson(String iosJson) {
		this.iosJson = iosJson;
	}

	public Boolean getDefaultPolicy() {
		return defaultPolicy;
	}

	public void setDefaultPolicy(Boolean defaultPolicy) {
		this.defaultPolicy = defaultPolicy;
	}

	public Timestamp getUpdateDateTime() {
		return updateDateTime;
	}

	public void setUpdateDateTime(Timestamp updateDateTime) {
		this.updateDateTime = updateDateTime;
	}

}
