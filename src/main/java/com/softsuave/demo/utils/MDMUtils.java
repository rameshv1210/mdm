package com.softsuave.demo.utils;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.security.Security;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import java.util.Base64;
import java.util.List;

import org.bouncycastle.cms.CMSException;
import org.bouncycastle.cms.CMSProcessable;
import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.SignerInformation;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

public class MDMUtils {


	public static void createIdentityCertificate(String certPath, String fileName)
			throws IOException, InterruptedException {

		Process process = Runtime.getRuntime().exec(
				certPath + "/identity.sh " + fileName);
		process.waitFor();
	}


	public static void signProfile(String certPath, String fileName)
			throws IOException, InterruptedException {
		
		Process process = Runtime.getRuntime().exec(
				certPath + "/profile.sh " + fileName);
		process.waitFor();
	}


	public static void removeProfile(String certPath, String fileName)
			throws IOException, InterruptedException {

		Process process = Runtime.getRuntime().exec(
				certPath + "/remove.sh " + fileName);
		process.waitFor();
	}


	public static String readCertificate(String filePath, String fileName)
			throws IOException, InterruptedException, CertificateException {

		CertificateFactory factory = CertificateFactory.getInstance("X.509");
		ByteArrayInputStream bias = new ByteArrayInputStream(
				Files.readAllBytes(Paths.get(filePath + fileName + ".crt")));
		X509Certificate x509Server = (X509Certificate) factory.generateCertificate(bias);

		return x509Server != null ? x509Server.getSerialNumber().toString() : null;
	}


	@SuppressWarnings("unchecked")
	public static String verifySignature(String signedData, String data)
			throws CMSException, UnsupportedEncodingException {

		String certSerialNumber = null;
		Security.addProvider(new BouncyCastleProvider());

		byte[] signedDataBytes = Base64.getDecoder().decode(signedData.getBytes());
		byte[] dataBytes;
		dataBytes = data.getBytes("UTF-8");

		CMSProcessable signedContent = new CMSProcessableByteArray(dataBytes);
		InputStream is = new ByteArrayInputStream(signedDataBytes);
		CMSSignedData sp = new CMSSignedData(signedContent, is);

		List<SignerInformation> signers = new ArrayList<SignerInformation>(sp
				.getSignerInfos().getSigners());
		certSerialNumber = signers.get(0).getSID().getSerialNumber().toString();

		return certSerialNumber;
	}


	public static void createProfile(String filePath, String fileName, String fileContent) throws IOException{
		String path = filePath + fileName + ".mobileconfig";
		Files.write(Paths.get(path), fileContent.getBytes(),
				StandardOpenOption.CREATE);
	}


	public static String decryptTicket(String key, String password, String ticket) throws IOException, InterruptedException {
	
		List<String> cmd = new ArrayList<String>();
		cmd.add("/var/AlertBootEncryptDelivery/AlertBootEncrypt.sh");
		cmd.add("-string");
		cmd.add("-privateKey");
		cmd.add(key);
		cmd.add("-input");
		cmd.add(ticket);
		if(password != null){
			cmd.add("-keyPassword");
			cmd.add(password);
		}

		Process proc = Runtime.getRuntime().exec(cmd.toArray(new String[cmd.size()]));
		proc.waitFor();

		InputStream in = proc.getInputStream();
		byte result[] = new byte[in.available()];
		in.read(result, 0, result.length);
		return new String(result);
	}
}
