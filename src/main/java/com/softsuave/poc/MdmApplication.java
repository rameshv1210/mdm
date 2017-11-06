package com.softsuave.poc;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.context.web.SpringBootServletInitializer;
import org.springframework.context.annotation.Bean;

import com.google.android.gcm.server.Sender;
import com.notnoop.apns.APNS;
import com.notnoop.apns.ApnsService;

@SpringBootApplication
public class MdmApplication extends SpringBootServletInitializer {


	@Value("${apns.certificate.path}")
	String apnsCertPath;

	@Value("${apns.certificate.password}")
	String apnsCertPassword;

	@Value("${gcm.token}")
	String gcmToken;


	@Override
	protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
		return application.sources(MdmApplication.class);
	}

	public static void main(String[] args) {
		SpringApplication.run(MdmApplication.class, args);
	}
	
	@Bean
	public Sender gcmService(){
		return new Sender(gcmToken);
	}

	@Bean
	public ApnsService apnsService(){
		ApnsService apnsService = APNS
				.newService()
				.withCert(apnsCertPath, apnsCertPassword)
				.withProductionDestination()
				.build();
		return apnsService;
	}

}