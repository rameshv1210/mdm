package com.softsuave.demo.exception;

public class AlertBootException extends RuntimeException {

	private static final long serialVersionUID = -7111961455255561115L;

	private AlertBootErrorMessage errorMessage;

	public AlertBootException(AlertBootErrorMessage errorMessage) {
		super(errorMessage.toString());
		this.errorMessage = errorMessage;
	}

	public AlertBootErrorMessage getErrorMessage() {
		return errorMessage;
	}

	public void setErrorMessage(AlertBootErrorMessage errorMessage) {
		this.errorMessage = errorMessage;
	}

}
