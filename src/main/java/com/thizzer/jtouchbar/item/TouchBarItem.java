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
package com.thizzer.jtouchbar.item;

import com.thizzer.jtouchbar.item.view.TouchBarView;

public class TouchBarItem {
	
	/**
	 * Naming for the following 4 variables is probably under Apple's copyright
	 * 
	 * Copyright (c) 2015-2017, Apple Inc.
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
		_view = view;
		_customizationAllowed = customizationAllowed;
	}

	public String getIdentifier() {
		return _identifier;
	}

	public void setIdentifier( String identifier ) {
		_identifier = identifier;
	}

	public TouchBarView getView() {
		return _view;
	}

	public void setView( TouchBarView view ) {
		_view = view;
	}

	public String getCustomizationLabel() {
		return _customizationLabel;
	}

	public void setCustomizationLabel( String customizationLabel ) {
		_customizationLabel = customizationLabel;
	}

	public boolean isCustomizationAllowed() {
		return _customizationAllowed;
	}

	public void setCustomizationAllowed( boolean customizationAllowed ) {
		_customizationAllowed = customizationAllowed;
	}
}
