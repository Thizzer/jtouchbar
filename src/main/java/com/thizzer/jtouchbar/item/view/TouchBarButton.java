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

import com.thizzer.jtouchbar.JTouchBarJNI;
import com.thizzer.jtouchbar.common.*;
import com.thizzer.jtouchbar.item.view.action.TouchBarViewAction;

public class TouchBarButton extends TouchBarView {

	public enum ButtonType {
		MOMENTARY_LIGHT,
		
		PUSH_ON_PUSH_OFF,
		
		TOGGLE,
		
		SWITCH,
		
		RADIO,
		
		MOMENTARY_CHANGE,
		
		ON_OFF,
		
		MOMENTARY_PUSH_IN,
		
		ACCELERATOR,
		
		MOMENTARY_MULTILEVEL_ACCELERATOR
	}
	
	private String _title;
	private String _alternateTitle;
	
	private Image _image;
	private Image _alternateImage;
	
	private int _imagePosition = ImagePosition.OVERLAPS;
	
	private Color _bezelColor;
	
	private TouchBarViewAction _action;
	
	private ButtonType _type = ButtonType.MOMENTARY_LIGHT;
	
	private boolean _allowsMixedState;
	
	public String getTitle() {
		return _title;
	}

	public void setTitle(String title) {
		_title = title;
		update();
	}
	
	public String getAlternateTitle() {
		return _alternateTitle;
	}

	public void setAlternatTitle(String alternateTitle) {
		_alternateTitle = alternateTitle;
		update();
	}

	public Image getImage() {
		return _image;
	}

	public void setImage(Image image) {
		_image = image;
		update();
	}
	
	public Image getAlternateImage() {
		return _alternateImage;
	}

	public void setAlternateImage(Image alternateImage) {
		_alternateImage = alternateImage;
		update();
	}

	public int getImagePosition() {
		return _imagePosition;
	}

	public void setImagePosition(int imagePosition) {
		_imagePosition = imagePosition;
		update();
	}

	public Color getBezelColor() {
		return _bezelColor;
	}

	public void setBezelColor(Color bezelColor) {
		_bezelColor = bezelColor;
		update();
	}
	
	public TouchBarViewAction getAction() {
		return _action;
	}

	public void setAction(TouchBarViewAction action) {
		_action = action;
		update();
	}
	
	public ButtonType getType() {
		return _type;
	}

	public void setType(ButtonType type) {
		_type = type;
		update();
	}

	int getButtonType() {
		return _type.ordinal();
	}
	
	public boolean getAllowsMixedState() {
		return _allowsMixedState;
	}
	
	public void setAllowsMixedState(boolean allowsMixedState) {
		_allowsMixedState = allowsMixedState;
		update();
	}
	
	public void setNextState() {
		JTouchBarJNI.callObjectSelector(getNativeInstancePointer(), "setNextState", true);
	}
	
	public int getState() {
		return JTouchBarJNI.callIntObjectSelector(getNativeInstancePointer(), "state");
	}
	
	public void trigger() {
		if(_action == null) {
			return;
		}
		
		_action.onCall(this);
	}

	public boolean isEnabled() {
		return _action == null || _action.isEnabled();
	}

	public void fireActionStateChanged() {
		if (this._action != null) {
			update();
		}
	}
}
