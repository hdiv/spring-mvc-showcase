package org.springframework.samples.mvc.partialform;

import org.springframework.samples.mvc.form.FormBean;

public class PartialFormBean extends FormBean {

	private String suggestType;

	/**
	 * @return the suggestType
	 */
	public String getSuggestType() {
		return suggestType;
	}

	/**
	 * @param suggestType the suggestType to set
	 */
	public void setSuggestType(String suggestType) {
		this.suggestType = suggestType;
	}

	public String toString() {
		StringBuilder sb = new StringBuilder();
		sb.append(super.toString());

		sb.append("suggestType=").append(suggestType);
		return sb.toString();
	}
}
