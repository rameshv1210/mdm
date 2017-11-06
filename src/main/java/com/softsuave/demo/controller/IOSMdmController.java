package com.softsuave.demo.controller;

import java.io.ByteArrayInputStream;
import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;

import com.softsuave.demo.exception.AlertBootErrorMessage;
import com.softsuave.demo.exception.AlertBootException;
import com.softsuave.demo.service.IOSMdmService;

@RestController
public class IOSMdmController {

	private static final Logger LOGGER = Logger.getLogger(IOSMdmController.class);

	@Autowired
	IOSMdmService iosMdmService;


	/***
	 * API to start device enrollment
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(method = RequestMethod.POST, value = "/enroll", consumes = "application/x-www-form-urlencoded")
	public void enroll(HttpServletRequest request, HttpServletResponse response) {

		String abTicket = StringUtils.trim(request.getParameter("abTicket"));
		String userId = StringUtils.trim(request.getParameter("userId"));

		iosMdmService.validateTicket(userId, abTicket);

		byte[] profile = iosMdmService.enrollService(userId);

		response.setContentType("application/x-apple-aspen-config");
		response.setHeader("Content-Disposition", "attachment; filename=AlertBoot.mobileconfig");

		try {
			FileCopyUtils.copy(new ByteArrayInputStream(profile), response.getOutputStream());
		} catch (IOException e) {
			LOGGER.error("Exception while sending profile", e);
			throw new AlertBootException(
					new AlertBootErrorMessage(HttpStatus.INTERNAL_SERVER_ERROR, "Exception while sending profile"));
		}
	}


	/***
	 * This API is contacted first after successful installation of profile in device.
	 * 
	 * @param request
	 * @param signature
	 */
	@RequestMapping(method = RequestMethod.PUT, value = "/checkIn")
	public void checkIn(@RequestBody String request,
			@RequestHeader(value = "Mdm-Signature") String signature) {
		LOGGER.info("CheckIn API called");
		iosMdmService.checkInService(request, signature);

	}


	/***
	 * Device will request this API for new commands or updated profile.
	 * 
	 * @param request
	 * @param response
	 */
	@RequestMapping(value = "/command", method = RequestMethod.PUT, produces = "application/x-plist")
	public void command(@RequestBody String request,
			@RequestHeader(value = "Mdm-Signature") String signature,
			HttpServletResponse response) {

		byte[] command = iosMdmService.commandService(request, signature);
		if(command != null){
			try {
				FileCopyUtils.copy(new ByteArrayInputStream(command), response.getOutputStream());
			} catch (IOException e) {
				LOGGER.error("Exception while sending command", e);
			}
		}
	}
}
