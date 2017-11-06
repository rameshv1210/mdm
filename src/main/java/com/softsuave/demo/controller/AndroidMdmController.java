package com.softsuave.demo.controller;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;

import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatus;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.request.model.Request;
import com.softsuave.demo.response.model.Response;
import com.softsuave.demo.service.AndroidMdmService;

@RestController
public class AndroidMdmController {

	private static final Logger LOGGER = Logger.getLogger(AndroidMdmController.class);

	@Autowired
	AndroidMdmService androidMdmService;

	@Value("${apk.path}")
	String apkPath;

	@RequestMapping(method = RequestMethod.POST, value = "/register", produces = "application/json")
	public Response register(@RequestBody Request request) {

		androidMdmService.validateTicket(request.getAbTicket(), request.getUserId());
		return androidMdmService.registerDevice(request.getUserId());

	}


	@RequestMapping(method = RequestMethod.POST, value = "/device/detail")
	public void saveDetail(@RequestBody Request request) {

		androidMdmService.saveDevice(request);

	}


	@RequestMapping(method = RequestMethod.POST, value = "/task")
	public Response tasks(@RequestBody Request request) {

		return androidMdmService.processTask(request);

	}


	@RequestMapping(method = RequestMethod.POST, value = "/unregister")
	public void unRegister(@RequestBody Request request) {
		
		androidMdmService.unRegisterDevice(request);
		
	}


	@RequestMapping(method = RequestMethod.GET, value = "/companyId")
	public Response getCompanyId(@RequestParam(name = "emailId") String userId, @RequestParam(name = "token") String token) {
		
		return androidMdmService.getCompanyId(userId, token);
		
	}


	@RequestMapping(method = RequestMethod.GET, value = "/apk")
	public void getNewAPK(@RequestParam(name = "abTicket") String abTicket,
			@RequestParam(name = "userId") String userId,
			HttpServletResponse response) {

		try {
			androidMdmService.validateTicket(abTicket, userId);
		} catch (AlertBootException e) {
			if (e.getErrorMessage().getStatus() != HttpStatus.UNAUTHORIZED)
				throw e;
		}

		response.setHeader("Content-Disposition","attachment; filename=alertboot.apk");

		try {
			FileCopyUtils.copy(new ByteArrayInputStream(Files.readAllBytes(Paths.get(apkPath))), response.getOutputStream());
		} catch (IOException e) {
			LOGGER.error("Exception while sending apk", e);
			throw new AlertBootException(new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while sending apk"));
		}

	}

}
