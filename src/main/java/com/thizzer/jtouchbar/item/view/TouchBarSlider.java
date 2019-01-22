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

import com.thizzer.jtouchbar.slider.SliderActionListener;

public class TouchBarSlider extends TouchBarView {

    private double _minValue;
    private double _maxValue;
    
    private SliderActionListener _actionListener;

	public SliderActionListener getActionListener() {
        return _actionListener;
    }
    
    public void setActionListener(SliderActionListener actionListener) {
        _actionListener = actionListener; // dynamically resolved so does not require update to be called.
    }

	public double getMinValue() {
		return _minValue;
	}

	public void setMinValue(double minValue) {
		_minValue = minValue;
		update();
	}

	public double getMaxValue() {
		return _maxValue;
	}

	public void setMaxValue(double maxValue) {
		_maxValue = maxValue;
		update();
	}
  
}
