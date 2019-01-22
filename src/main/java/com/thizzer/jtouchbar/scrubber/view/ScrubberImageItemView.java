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
package com.thizzer.jtouchbar.scrubber.view;

import com.thizzer.jtouchbar.common.*;

public class ScrubberImageItemView extends ScrubberView {

    private Image _image;
    private int _alignment;
	
    public Image getImage() {
		return _image;
	}
	
	public void setImage(Image image) {
		_image = image;
	}
	
	public int getAlignment() {
		return _alignment;
	}
	
	public void setAlignment(int alignment) {
		_alignment = alignment;
	}
}
