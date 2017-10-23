/**
 * JTouchBar
 *
 * Copyright (c) 2017 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
package com.thizzer.jtouchbar;

import java.awt.Component;
import java.util.ArrayList;
import java.util.List;

import org.eclipse.swt.widgets.Shell;

import com.thizzer.jtouchbar.awt.AWTUtils;
import com.thizzer.jtouchbar.item.TouchBarItem;
import com.thizzer.jtouchbar.swt.SWTUtils;

public class JTouchBar {

	private String _customizationIdentifier;
	private String _principalItemIdentifier;
	
	private List<TouchBarItem> _items;
	
	public String getCustomizationIdentifier() {
		return _customizationIdentifier;
	}

	public void setCustomizationIdentifier( String customizationIdentifier ) {
		_customizationIdentifier = customizationIdentifier;
	}
	
	public String getPrincipalItemIdentifier() {
		return _principalItemIdentifier;
	}

	public void setPrincipalItemIdentifier( String principalItemIdentifier ) {
		_principalItemIdentifier = principalItemIdentifier;
	}

	public List<TouchBarItem> getItems() {
		if(_items == null) { _items = new ArrayList<TouchBarItem>(); }
		return _items;
	}

	public void setItems( List<TouchBarItem> items ) {
		_items = items;
	}
	
	public void addItem(TouchBarItem touchBarItem) {
		getItems().add(touchBarItem);
	}
	
	public void enableForComponent(Component c) {
		long viewPointer = AWTUtils.getViewPointer(c);
		JTouchBarJNI.setTouchBar0(viewPointer, this);
	}
	
	public void enableForShell(Shell shell) {
		long viewPointer = SWTUtils.getViewPointer(shell);
		JTouchBarJNI.setTouchBar0(viewPointer, this);
	}
}
