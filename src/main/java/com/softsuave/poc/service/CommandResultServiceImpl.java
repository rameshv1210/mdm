package com.softsuave.poc.service;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.sql.Timestamp;
import java.util.Date;

import org.apache.log4j.Logger;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.dd.plist.NSArray;
import com.dd.plist.NSData;
import com.dd.plist.NSDate;
import com.dd.plist.NSDictionary;
import com.dd.plist.NSNumber;
import com.dd.plist.NSObject;
import com.dd.plist.NSString;
import com.softsuave.poc.model.UserCommand;
import com.softsuave.poc.repository.AndroidCommandResultRepository;
import com.softsuave.poc.repository.IosCommandResultRepository;

@Service
public class CommandResultServiceImpl implements CommandResultService {

	private static final Logger LOGGER = Logger.getLogger(CommandResultServiceImpl.class);

	@Autowired
	IosCommandResultRepository iosCommandResultRepository;

	@Autowired
	AndroidCommandResultRepository androidCommandResultRepository;

	@Override
	public void saveProfileList(UserCommand userCommand, NSArray profileArray, Long userId) {
		StringBuffer payloadIdentifier = new StringBuffer();
		StringBuffer payloadOrganization = new StringBuffer();
		StringBuffer payloadVersion = new StringBuffer();
		StringBuffer payloadDescription = new StringBuffer();
		for (int i = 0; i < profileArray.count(); i++) {
			NSDictionary profile = (NSDictionary) profileArray.objectAtIndex(i);
			if(i == 0){
				payloadIdentifier = payloadIdentifier.append(profile.objectForKey("PayloadIdentifier").toString());
				payloadOrganization = payloadOrganization.append(profile.objectForKey("PayloadOrganization").toString());
				payloadVersion = payloadVersion.append(profile.objectForKey("PayloadVersion").toString());
				payloadDescription = payloadDescription.append(profile.objectForKey("PayloadDescription").toString());
			} else {
				payloadIdentifier = payloadIdentifier.append(",").append(profile.objectForKey("PayloadIdentifier").toString());
				payloadOrganization = payloadOrganization.append(",").append(profile.objectForKey("PayloadOrganization").toString());
				payloadVersion = payloadVersion.append(",").append(profile.objectForKey("PayloadVersion").toString());
				payloadDescription = payloadDescription.append(",").append(profile.objectForKey("PayloadDescription").toString());
			}
		}
		iosCommandResultRepository.saveIosProfileList(userId, userCommand.getDeviceUuid(), profileArray.count(), payloadIdentifier.toString(),
				payloadOrganization.toString(), payloadVersion.toString(),
				payloadDescription.toString());
	}


	@Override
	public void saveProvisioningProfileList(UserCommand userCommand, NSArray profileArray, Long userId) {
		StringBuffer name = new StringBuffer();
		StringBuffer uuid = new StringBuffer();
		StringBuffer expiryDate = new StringBuffer();
		for (int i = 0; i < profileArray.count(); i++) {
			NSDictionary profile = (NSDictionary) profileArray.objectAtIndex(i);
			if(i == 0){
				name = name.append(profile.objectForKey("Name").toString());
				uuid = uuid.append(profile.objectForKey("UUID").toString());
				Date date = ((NSDate)profile.objectForKey("ExpiryDate")).getDate();
				expiryDate = expiryDate.append(new Timestamp(date.getTime()).toString());
			} else {
				name = name.append(",").append(profile.objectForKey("Name").toString());
				uuid = uuid.append(",").append(profile.objectForKey("UUID").toString());
				Date date = ((NSDate)profile.objectForKey("ExpiryDate")).getDate();
				expiryDate = expiryDate.append(",").append(new Timestamp(date.getTime()).toString());
			}
		}
		iosCommandResultRepository.saveIosProvisioningProfileList(userId, userCommand.getDeviceUuid(), profileArray.count(), name.toString(),
				uuid.toString(), expiryDate.toString());
	}


	@Override
	public void saveCertificateList(UserCommand userCommand, NSArray profileArray, Long userId) {
		StringBuffer commonName = new StringBuffer();
		StringBuffer data = new StringBuffer();
		StringBuffer isIdentity = new StringBuffer();
		for (int i = 0; i < profileArray.count(); i++) {
			NSDictionary profile = (NSDictionary) profileArray.objectAtIndex(i);
			if(i == 0){
				commonName = commonName.append(profile.objectForKey("CommonName").toString());
				data = data.append(((NSData)profile.objectForKey("Data")).getBase64EncodedData());
				isIdentity = isIdentity.append(((NSObject)profile.objectForKey("IsIdentity")).toString());
			} else {
				commonName = commonName.append(",").append(profile.objectForKey("CommonName").toString());
				data = data.append(",").append(((NSData)profile.objectForKey("Data")).getBase64EncodedData());
				isIdentity = isIdentity.append(",").append(((NSObject)profile.objectForKey("IsIdentity")).toString());
			}
		}
		iosCommandResultRepository.saveIosCertificateList(userId, userCommand.getDeviceUuid(), profileArray.count(), commonName.toString(),
				data.toString(), isIdentity.toString());
	}


	@Override
	public void saveInstalledApplicationList(UserCommand userCommand, NSArray profileArray, Long userId) {

		StringBuffer bundleSize = new StringBuffer();
		StringBuffer dynamicSize = new StringBuffer();
		StringBuffer identifier = new StringBuffer();
		StringBuffer isValidated = new StringBuffer();
		StringBuffer name = new StringBuffer();
		StringBuffer version = new StringBuffer();

		for (int i = 0; i < profileArray.count(); i++) {
			NSDictionary profile = (NSDictionary) profileArray.objectAtIndex(i);

			if(i == 0){

				bundleSize = bundleSize.append(((NSNumber) profile.objectForKey("BundleSize")).intValue());
				dynamicSize = dynamicSize.append(((NSNumber) profile.objectForKey("DynamicSize")).intValue());
				identifier = identifier.append(profile.objectForKey("Identifier").toString());
				isValidated = isValidated.append(((NSObject)profile.objectForKey("IsValidated")).toString());
				name = name.append(profile.objectForKey("Name").toString());
				version = version.append(profile.objectForKey("Version").toString());

			} else {

				bundleSize = bundleSize.append(",").append(((NSNumber) profile.objectForKey("BundleSize")).intValue());
				dynamicSize = dynamicSize.append(",").append(((NSNumber) profile.objectForKey("DynamicSize")).intValue());
				identifier = identifier.append(",").append(profile.objectForKey("Identifier").toString());
				isValidated = isValidated.append(",").append(((NSObject)profile.objectForKey("IsValidated")).toString());
				name = name.append(",").append(profile.objectForKey("Name").toString());
				version = version.append(",").append(profile.objectForKey("Version").toString());

			}
		}

		iosCommandResultRepository.saveIosInstalledApplicationList(userId,
				userCommand.getDeviceUuid(), profileArray.count(),
				bundleSize.toString(), dynamicSize.toString(),
				identifier.toString(), isValidated.toString(), name.toString(), version.toString());
	}


	@Override
	public void saveSecurityInfo(UserCommand userCommand, NSDictionary profile, Long userId) {

		int hardwareEncryptionCaps = ((NSNumber) profile.objectForKey("HardwareEncryptionCaps")).intValue();
		String passcodeCompliant = ((NSObject)profile.objectForKey("PasscodeCompliant")).toString();
		String passcodeCompliantWithProfiles = ((NSObject)profile.objectForKey("PasscodeCompliantWithProfiles")).toString();
		int passcodeLockGracePeriod = ((NSNumber) profile.objectForKey("PasscodeLockGracePeriod")).intValue();
		int passcodeLockGracePeriodEnforced = ((NSNumber) profile.objectForKey("PasscodeLockGracePeriodEnforced")).intValue();
		String passcodePresent = ((NSObject)profile.objectForKey("PasscodePresent")).toString();

		iosCommandResultRepository.saveIosSecurityInfo(userId, userCommand.getDeviceUuid(), hardwareEncryptionCaps,
				passcodeCompliant.toString(), passcodeCompliantWithProfiles.toString(), passcodeLockGracePeriod,
				passcodeLockGracePeriodEnforced, passcodePresent.toString());
	}


	@Override
	public void saveDeviceInformation(UserCommand userCommand, NSDictionary profile, Long userId) {

		StringBuffer deviceInfo = new StringBuffer();

		NSDate lastCloudBackupDate = (NSDate) profile.objectForKey("LastCloudBackupDate");
		deviceInfo = setDeviceInfo(deviceInfo, false, lastCloudBackupDate);

		NSString deviceName = (NSString) profile.objectForKey("DeviceName");
		deviceInfo = setDeviceInfo(deviceInfo, true, deviceName);

		NSString osVersion = (NSString) profile.objectForKey("OSVersion");
		deviceInfo = setDeviceInfo(deviceInfo, true, osVersion);

		NSString buildVersion = (NSString) profile.objectForKey("BuildVersion");
		deviceInfo = setDeviceInfo(deviceInfo, true, buildVersion);

		NSString modelName = (NSString) profile.objectForKey("ModelName");
		deviceInfo = setDeviceInfo(deviceInfo, true, modelName);

		NSString model = (NSString) profile.objectForKey("Model");
		deviceInfo = setDeviceInfo(deviceInfo, true, model);

		NSString productName = (NSString) profile.objectForKey("ProductName");
		deviceInfo = setDeviceInfo(deviceInfo, true, productName);

		NSString serialNumber = (NSString) profile.objectForKey("SerialNumber");
		deviceInfo = setDeviceInfo(deviceInfo, true, serialNumber);

		NSNumber deviceCapacity = (NSNumber) profile.objectForKey("DeviceCapacity");
		deviceInfo = setDeviceInfo(deviceInfo, true, deviceCapacity);

		NSNumber availableCapacity = (NSNumber) profile.objectForKey("AvailableDevice-Capacity");
		deviceInfo = setDeviceInfo(deviceInfo, true, availableCapacity);

		NSNumber batteryLevel = (NSNumber) profile.objectForKey("BatteryLevel");
		deviceInfo = setDeviceInfo(deviceInfo, true, batteryLevel);

		NSNumber cellularTechnology = (NSNumber) profile.objectForKey("CellularTechnology");
		deviceInfo = setDeviceInfo(deviceInfo, true, cellularTechnology);

		NSString IMEI = (NSString) profile.objectForKey("IMEI");
		deviceInfo = setDeviceInfo(deviceInfo, true, IMEI);

		NSString MEID = (NSString) profile.objectForKey("MEID");
		deviceInfo = setDeviceInfo(deviceInfo, true, MEID);

		NSString modemFirmwareVersion = (NSString) profile.objectForKey("ModemFirmwareVersion");
		deviceInfo = setDeviceInfo(deviceInfo, true, modemFirmwareVersion);

		NSObject isSupervised = (NSObject) profile.objectForKey("IsSupervised");
		deviceInfo = setDeviceInfo(deviceInfo, true, isSupervised);

		NSString easDeviceIdentifier = (NSString) profile.objectForKey("EASDeviceIdentifier");
		deviceInfo = setDeviceInfo(deviceInfo, true, easDeviceIdentifier);

		NSObject isCloudBackupEnabled = (NSObject) profile.objectForKey("IsCloudBackupEnabled");
		deviceInfo = setDeviceInfo(deviceInfo, true, isCloudBackupEnabled);

		NSString ICCID = (NSString) profile.objectForKey("ICCID");
		deviceInfo = setDeviceInfo(deviceInfo, true, ICCID);

		NSString bluetoothMAC = (NSString) profile.objectForKey("BluetoothMAC");
		deviceInfo = setDeviceInfo(deviceInfo, true, bluetoothMAC);

		NSString wifiMAC = (NSString) profile.objectForKey("WiFiMAC");
		deviceInfo = setDeviceInfo(deviceInfo, true, wifiMAC);

		NSString phoneNumber = (NSString) profile.objectForKey("PhoneNumber");
		deviceInfo = setDeviceInfo(deviceInfo, true, phoneNumber);

		NSObject isRoaming = (NSObject) profile.objectForKey("IsRoaming");
		deviceInfo = setDeviceInfo(deviceInfo, true, isRoaming);

		NSString subscriberMCC = (NSString) profile.objectForKey("SubscriberMCC");
		deviceInfo = setDeviceInfo(deviceInfo, true, subscriberMCC);

		NSString subscriberMNC = (NSString) profile.objectForKey("SubscriberMNC");
		deviceInfo = setDeviceInfo(deviceInfo, true, subscriberMNC);

		NSString currentMCC = (NSString) profile.objectForKey("CurrentMCC");
		deviceInfo = setDeviceInfo(deviceInfo, true, currentMCC);

		NSString currentMNC = (NSString) profile.objectForKey("CurrentMNC");
		deviceInfo = setDeviceInfo(deviceInfo, true, currentMNC);

		iosCommandResultRepository.saveIosDeviceInformation(userId, userCommand.getDeviceUuid(), deviceInfo.toString());
	}


	@Override
	public void saveApplicationList(UserCommand userCommand, String payload, Long userId) {

		StringBuffer isActive = new StringBuffer();
		StringBuffer packageApi = new StringBuffer();
		StringBuffer uss = new StringBuffer();
		StringBuffer isSystemApp = new StringBuffer();
		StringBuffer version = new StringBuffer();
		StringBuffer name = new StringBuffer();

		JSONArray appList;
		try {
			appList = new JSONArray(URLDecoder.decode(payload, "UTF-8"));

			for (int i = 0; i < appList.length(); i++) {
				JSONObject app = appList.getJSONObject(i);

				if (i == 0) {

					isActive = isActive.append(app.getBoolean("isActive"));
					packageApi = packageApi.append(app.getString("package"));
					uss = uss.append(app.optInt("USS", 0));
					isSystemApp = isSystemApp.append(app.getBoolean("isSystemApp"));
					version = version.append(app.optString("version", "0.0"));
					name = name.append(app.getString("name"));

				} else {

					isActive = isActive.append(",").append(app.getBoolean("isActive"));
					packageApi = packageApi.append(",").append(app.getString("package"));
					uss = uss.append(",").append(app.optInt("USS", 0));
					isSystemApp = isSystemApp.append(",").append(app.getBoolean("isSystemApp"));
					version = version.append(",").append(app.optString("version", "0.0"));
					name = name.append(",").append(app.getString("name"));

				}
			}

			androidCommandResultRepository.saveAndroidApplicationList(userId,
							userCommand.getDeviceUuid(), appList.length(),
							isActive.toString(), packageApi.toString(),
							uss.toString(), isSystemApp.toString(),
							version.toString(), name.toString());

		} catch (JSONException | UnsupportedEncodingException e) {
			LOGGER.info("Error while saving android App List", e);
		}

	}


	@Override
	public void saveDeviceInfo(UserCommand userCommand, String payload, Long userId) {
		
		StringBuffer deviceInfo = new StringBuffer();
		try {
			
			JSONObject device = new JSONObject(payload);
			deviceInfo.append(device.optString("SERIAL", ""));
			deviceInfo.append(",").append(device.optString("IMEI", ""));
			deviceInfo.append(",").append(device.optString("IMSI", ""));
			deviceInfo.append(",").append(device.optString("MAC", ""));
			deviceInfo.append(",").append(device.optString("DEVICE_MODEL", ""));
			deviceInfo.append(",").append(device.optString("VENDOR", ""));
			deviceInfo.append(",").append(device.optString("OS_VERSION", ""));
			deviceInfo.append(",").append(device.optString("OS_BUILD_DATE", ""));
			deviceInfo.append(",").append(device.optString("DEVICE_NAME", ""));
			deviceInfo.append(",").append(device.optString("LATITUDE", ""));
			deviceInfo.append(",").append(device.optString("LONGITUDE", ""));
			deviceInfo.append(",").append(device.optString("ENCRYPTION_ENABLED", ""));
			deviceInfo.append(",").append(device.optString("INTERNAL_TOTAL_MEMORY", ""));
			deviceInfo.append(",").append(device.optString("INTERNAL_AVAILABLE_MEMORY", ""));
			deviceInfo.append(",").append(device.optString("EXTERNAL_TOTAL_MEMORY", ""));
			deviceInfo.append(",").append(device.optString("EXTERNAL_AVAILABLE_MEMORY", ""));
			deviceInfo.append(",").append(device.optString("OPERATOR", ""));
			deviceInfo.append(",").append(device.optString("BATTERY_LEVEL", ""));
			deviceInfo.append(",").append(device.optString("HEALTH", ""));
			deviceInfo.append(",").append(device.optString("PLUGGED", ""));
			
			androidCommandResultRepository.saveAndroidDeviceInfo(userId, userCommand.getDeviceUuid(), deviceInfo.toString());
		} catch (Exception ex){
			LOGGER.info("Error while saving android device info", ex);
		}
	}


	@Override
	public void saveDeviceLocation(UserCommand userCommand, String payload, Long userId) {

		try {
			JSONObject device = new JSONObject(payload);

			androidCommandResultRepository.saveAndroidDeviceLocation(userId,
					userCommand.getDeviceUuid(), String.valueOf(device.getDouble("longitude")),
					String.valueOf(device.getDouble("latitude")));
		} catch (Exception ex){
			LOGGER.info("Error while saving android device Location", ex);
		}
	}


	private StringBuffer setDeviceInfo(StringBuffer result, Boolean delimiter, NSObject value) {
		if(delimiter)
			result.append("|");
		if(value != null) {
			if (value instanceof NSDate)
				result.append(new Timestamp(((NSDate) value).getDate().getTime()).toString());
			else
				result.append(value.toString());
		}
		return result;
	}
}
