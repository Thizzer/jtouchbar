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
package com.thizzer.jtouchbar.item;

import java.util.Observable;
import java.util.Observer;

import com.thizzer.jtouchbar.JTouchBarJNI;
import com.thizzer.jtouchbar.NativeLinkObject;
import com.thizzer.jtouchbar.item.view.TouchBarView;

public class TouchBarItem extends NativeLinkObject implements Observer {
	
	/**
	 * Naming for the following 4 variables is probably under Apple's copyright
	 * 
	 * Copyright (c) 2015-2018, Apple Inc.
     * All rights reserved.
	 */
	public static final String NSTouchBarItemIdentifierFixedSpaceSmall = "NSTouchBarItemIdentifierFixedSpaceSmall";
	public static final String NSTouchBarItemIdentifierFixedSpaceLarge = "NSTouchBarItemIdentifierFixedSpaceLarge";
	public static final String NSTouchBarItemIdentifierFlexibleSpace = "NSTouchBarItemIdentifierFlexibleSpace";
	public static final String NSTouchBarItemIdentifierOtherItemsProxy = "NSTouchBarItemIdentifierOtherItemsProxy";
	
	private String _identifier;
	private TouchBarView _view;
	
	private String _customizationLabel;
	private boolean _customizationAllowed;
	
	public TouchBarItem(String identifier) {
		this(identifier, null);
	}
	
	public TouchBarItem(String identifier, TouchBarView view) {
		this(identifier, view, false);
	}
	
	public TouchBarItem(String identifier, TouchBarView view, boolean customizationAllowed) {
		_identifier = identifier;
		_customizationAllowed = customizationAllowed;
		
		setView(view);
	}

	public String getIdentifier() {
		return _identifier;
	}

	public void setIdentifier(String identifier) {
		_identifier = identifier;
		update();
	}

	public TouchBarView getView() {
		return _view;
	}

	public void setView(TouchBarView view) {
		_view = view;
		
		if(_view != null) {
			_view.deleteObservers();
			_view.addObserver(this);
		}
		
		update();
	}

	public String getCustomizationLabel() {
		return _customizationLabel;
	}

	public void setCustomizationLabel(String customizationLabel) {
		_customizationLabel = customizationLabel;
		update();
	}

	public boolean isCustomizationAllowed() {
		return _customizationAllowed;
	}

	public void setCustomizationAllowed(boolean customizationAllowed) {
		_customizationAllowed = customizationAllowed;
		update();
	}
	
	@Override
	public void update(Observable observable, Object obj) {
		update();
	}
	
	protected void update() {
		updateNativeInstance();
	}
		
	private void updateNativeInstance() {
		if(getNativeInstancePointer() == 0) {
			return;
		}
		
		JTouchBarJNI.updateTouchBarItem(getNativeInstancePointer());
	}
}
