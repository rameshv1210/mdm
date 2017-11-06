package com.softsuave.poc.service;

public interface IOSMdmService {

	void validateTicket(String userId, String abTicket);

	byte[] enrollService(String userId) ;

	void checkInService(String request, String signature);

	byte[] commandService(String request, String signature);

}
