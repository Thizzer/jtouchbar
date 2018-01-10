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
import javafx.stage.Window;
import org.eclipse.swt.widgets.Shell;

import java.util.ArrayList;
import java.util.List;

import com.sun.glass.ui.Application;
import com.thizzer.jtouchbar.awt.AWTUtils;
import com.thizzer.jtouchbar.swt.SWTUtils;
import com.thizzer.jtouchbar.javafx.JavaFXUtils;

import com.thizzer.jtouchbar.item.TouchBarItem;


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
	
	public void show(Component c) {
		long viewPointer = AWTUtils.getViewPointer(c);
		JTouchBarJNI.setTouchBar0(viewPointer, this);
	}
	
	public void show(Shell shell) {
		long viewPointer = SWTUtils.getViewPointer(shell);
		JTouchBarJNI.setTouchBar0(viewPointer, this);
	}
	
	public void show(Window window) {
		if(window == null) {
			return;
		}
		Application.invokeAndWait(new Runnable() {
			@Override
			public void run() {
				long viewPointer = JavaFXUtils.getViewPointer(window);
				JTouchBarJNI.setTouchBar0(viewPointer, JTouchBar.this);
			}
		});
	}
	
	public void hide(Component c) {
		if(c == null) {
			return;
		}
		long viewPointer = AWTUtils.getViewPointer(c);
		JTouchBarJNI.setTouchBar0(viewPointer, null);
	}
	
	public void hide(Shell shell) {
		if(shell == null) {
			return;
		}
		long viewPointer = SWTUtils.getViewPointer(shell);
		JTouchBarJNI.setTouchBar0(viewPointer, null);
	}
	
	public void hide(Window window) {
		long viewPointer = JavaFXUtils.getViewPointer(window);
		JTouchBarJNI.setTouchBar0(viewPointer, null);
	}
}
