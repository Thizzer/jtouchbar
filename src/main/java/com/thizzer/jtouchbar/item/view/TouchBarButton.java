/**
 * JTouchBar
 *
 * Copyright (c) 2018 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
package com.thizzer.jtouchbar.item.view;

import com.thizzer.jtouchbar.common.*;
import com.thizzer.jtouchbar.item.view.action.TouchBarViewAction;

public class TouchBarButton extends TouchBarView {

	private String _title;
	
	private Image _image;
	private int _imagePosition = ImagePosition.OVERLAPS;
	
	private Color _bezelColor;
	
	private TouchBarViewAction _action;
	
	public String getTitle() {
		return _title;
	}

	public void setTitle(String title) {
		_title = title;
		update();
	}

	public Image getImage() {
		return _image;
	}

	public void setImage(Image image) {
		_image = image;
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
