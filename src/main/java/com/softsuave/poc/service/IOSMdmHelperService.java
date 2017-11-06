package com.softsuave.poc.service;

import com.dd.plist.NSDictionary;

public interface IOSMdmHelperService {

	NSDictionary parseRequestToPlist(String request);

	void processDeviceMessage(NSDictionary dictionary, Long userId);

	byte[] processDeviceRequest(NSDictionary dictionary, Long userId);

}
