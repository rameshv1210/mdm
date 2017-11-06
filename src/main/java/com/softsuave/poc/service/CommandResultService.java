package com.softsuave.poc.service;

import com.dd.plist.NSArray;
import com.dd.plist.NSDictionary;
import com.softsuave.poc.model.UserCommand;

public interface CommandResultService {

	void saveProfileList(UserCommand userCommand, NSArray profileArray, Long userId);

	void saveProvisioningProfileList(UserCommand userCommand, NSArray profileArray, Long userId);

	void saveCertificateList(UserCommand userCommand, NSArray profileArray, Long userId);

	void saveInstalledApplicationList(UserCommand userCommand, NSArray profileArray, Long userId);

	void saveSecurityInfo(UserCommand userCommand, NSDictionary profile, Long userId);

	void saveDeviceInformation(UserCommand userCommand, NSDictionary profile, Long userId);

	void saveApplicationList(UserCommand userCommand, String payload, Long userId);

	void saveDeviceInfo(UserCommand userCommand, String payload, Long userId);

	void saveDeviceLocation(UserCommand userCommand, String payload, Long userId);

}
