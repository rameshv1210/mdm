package com.softsuave.poc.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

import com.softsuave.poc.exception.AlertBootException;

@ControllerAdvice
public class ExceptionControllerAdvice {


	/***
	 * Exceptional handler to send proper response to client.
	 * 
	 * @param ex
	 * @return
	 */
	@ExceptionHandler(AlertBootException.class)
	public ResponseEntity<String> exceptionHandler(AlertBootException ex) {
		return new ResponseEntity<String>(ex.getErrorMessage().getMessage(), ex
				.getErrorMessage().getStatus());
	}
}
