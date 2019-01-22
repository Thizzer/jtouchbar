/**
 * JTouchBar
 *
 * Copyright (c) 2018 - 2019 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
package com.thizzer.jtouchbar.item.view;

public class TouchBarTextField extends TouchBarView {

	private String _stringValue;

	public String getStringValue() {
		return _stringValue;
	}

	public void setStringValue(String stringValue) {
		_stringValue = stringValue;
		update();
	}
}
