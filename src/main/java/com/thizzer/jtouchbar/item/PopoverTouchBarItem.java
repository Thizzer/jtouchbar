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
import com.thizzer.jtouchbar.JTouchBarJNI;
import com.thizzer.jtouchbar.common.Image;
import com.thizzer.jtouchbar.item.view.TouchBarView;

public class PopoverTouchBarItem extends TouchBarItem {

	private TouchBarView _collapsedRepresentation;
	private Image _collapsedRepresentationImage;
	private String _collapsedRepresentationLabel;
	
	private JTouchBar _popoverTouchBar;
	private JTouchBar _pressAndHoldTouchBar;
	
	private Boolean _showsCloseButton;

	public PopoverTouchBarItem(String identifier) {
		super(identifier);
	}
	
	public TouchBarView getCollapsedRepresentation() {
		return _collapsedRepresentation;
	}

	public void setCollapsedRepresentation(TouchBarView collapsedRepresentation) {
		_collapsedRepresentation = collapsedRepresentation;
		update();
	}

	public Image getCollapsedRepresentationImage() {
		return _collapsedRepresentationImage;
	}

	public void setCollapsedRepresentationImage(Image collapsedRepresentationImage) {
		_collapsedRepresentationImage = collapsedRepresentationImage;
		update();
	}

	public String getCollapsedRepresentationLabel() {
		return _collapsedRepresentationLabel;
	}

	public void setCollapsedRepresentationLabel(String collapsedRepresentationLabel) {
		_collapsedRepresentationLabel = collapsedRepresentationLabel;
		update();
	}

	public JTouchBar getPopoverTouchBar() {
		return _popoverTouchBar;
	}

	public void setPopoverTouchBar(JTouchBar popoverTouchBar) {
		_popoverTouchBar = popoverTouchBar;
		update();
	}

	public JTouchBar getPressAndHoldTouchBar() {
		return _pressAndHoldTouchBar;
	}

	public void setPressAndHoldTouchBar(JTouchBar pressAndHoldTouchBar) {
		_pressAndHoldTouchBar = pressAndHoldTouchBar;
		update();
	}
	
	public void showPopover() {
		JTouchBarJNI.callObjectSelector(getNativeInstancePointer(), "showPopover", true);
	}
	
	public void dismissPopover() {
		JTouchBarJNI.callObjectSelector(getNativeInstancePointer(), "dismissPopover", true);
	}

	public Boolean isShowsCloseButton() {
		return _showsCloseButton;
	}

	public void setShowsCloseButton(Boolean showsCloseButton) {
		_showsCloseButton = showsCloseButton;
		update();
	}
}
