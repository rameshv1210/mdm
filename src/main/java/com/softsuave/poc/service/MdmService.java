package com.softsuave.poc.service;

import com.softsuave.poc.model.UserIdentity;
import com.softsuave.poc.request.model.Request;

public interface MdmService {

	void validateAbTicket(String abTicket, Long userId) throws Exception;

	String createIdentityCertificate(String userId);

	Long identifyUser(String request, String signature);

	UserIdentity identifyUser(String serialNumber);

	void sendPush(Request request);

	void receiveDeviceCommand(Request request);

	void executeDeviceCommand(Request request);

}
