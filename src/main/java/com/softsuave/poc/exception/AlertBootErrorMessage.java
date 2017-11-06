package com.softsuave.poc.exception;

import org.springframework.http.HttpStatus;

public class AlertBootErrorMessage {

	private HttpStatus status;
	private String message;

	public AlertBootErrorMessage(HttpStatus status, String message) {
		this.status = status;
		this.message = message;
	}

	public HttpStatus getStatus() {
		return status;
	}

	public void setStatus(HttpStatus status) {
		this.status = status;
	}

	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	@Override
	public String toString() {
		return "{ status : " + status + " , message : " + message + " }";
	}
}
