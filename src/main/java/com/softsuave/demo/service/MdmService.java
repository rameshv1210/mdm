package com.softsuave.demo.service;

import com.softsuave.demo.model.UserIdentity;
import com.softsuave.demo.request.model.Request;

public interface MdmService {

	void validateAbTicket(String abTicket, Long userId) throws Exception;

	String createIdentityCertificate(String userId);

	Long identifyUser(String request, String signature);

	UserIdentity identifyUser(String serialNumber);

	void sendPush(Request request);

	void receiveDeviceCommand(Request request);

	void executeDeviceCommand(Request request);

}
