package com.softsuave.demo.service;

import com.softsuave.demo.request.model.Request;
import com.softsuave.demo.response.model.Response;

public interface AndroidMdmService {

	void validateTicket(String abTicket, String userId);

	Response registerDevice(String emailId);

	void saveDevice(Request request);

	Response processTask(Request request);

	void unRegisterDevice(Request request);

	Response getCompanyId(String userName, String token);

}
