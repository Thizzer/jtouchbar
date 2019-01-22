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

import com.thizzer.jtouchbar.JTouchBar;
import com.thizzer.jtouchbar.item.view.TouchBarView;

public class GroupTouchBarItem extends TouchBarItem {

	private JTouchBar _groupTouchBar;

	/**
	 * A Boolean value that specifies that items should have equal widths when possible.
	 */
	private boolean _prefersEqualWidths;
	 
	/**
	 * The preferred width for items in the group when prefersEqualWidths is true.
	 */
	private float _preferredItemWidth;
	
	public GroupTouchBarItem( String identifier ) {
		super( identifier );
	}
	
	public GroupTouchBarItem( String identifier, TouchBarView view ) {
		super( identifier, view );
	}
	
	public JTouchBar getGroupTouchBar() {
		if(_groupTouchBar == null) { _groupTouchBar = new JTouchBar(); }
		return _groupTouchBar;
	}

	public void setGroupTouchBar( JTouchBar groupTouchBar ) {
		_groupTouchBar = groupTouchBar;
	}

	public boolean isPrefersEqualWidths() {
		return _prefersEqualWidths;
	}

	public void setPrefersEqualWidths( boolean prefersEqualWidths ) {
		_prefersEqualWidths = prefersEqualWidths;
	}

	public float getPreferredItemWidth() {
		return _preferredItemWidth;
	}

	public void setPreferredItemWidth( float preferredItemWidth ) {
		_preferredItemWidth = preferredItemWidth;
	}
}
