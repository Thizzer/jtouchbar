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

import com.thizzer.jtouchbar.common.Color;
import com.thizzer.jtouchbar.scrubber.ScrubberActionListener;
import com.thizzer.jtouchbar.scrubber.ScrubberDataSource;

public class TouchBarScrubber extends TouchBarView {

    private int _mode;
    private boolean _showsArrowButtons;
    private Color _backgroundColor;
    private int _selectionOverlayStyle;
    private int _selectionBackgroundStyle;
    
    private ScrubberActionListener _actionListener;
    private ScrubberDataSource _dataSource;

    public int getMode() {
		return _mode;
	}

	public void setMode(int mode) {
		_mode = mode;
		update();
	}

	public boolean getShowsArrowButtons() {
		return _showsArrowButtons;
	}

	public void setShowsArrowButtons(boolean showsArrowButtons) {
		_showsArrowButtons = showsArrowButtons;
		update();
	}

	public Color getBackgroundColor() {
		return _backgroundColor;
	}

	public void setBackgroundColor(Color backgroundColor) {
		_backgroundColor = backgroundColor;
		update();
	}

	public int getSelectionOverlayStyle() {
		return _selectionOverlayStyle;
	}

	public void setSelectionOverlayStyle(int selectionOverlayStyle) {
		_selectionOverlayStyle = selectionOverlayStyle;
		update();
	}

	public int getSelectionBackgroundStyle() {
		return _selectionBackgroundStyle;
	}

	public void setSelectionBackgroundStyle(int selectionBackgroundStyle) {
		_selectionBackgroundStyle = selectionBackgroundStyle;
		update();
	}

	public ScrubberActionListener getActionListener() {
        return _actionListener;
    }
    
    public void setActionListener(ScrubberActionListener actionListener) {
        _actionListener = actionListener; // dynamically resolved so does not require update to be called.
    }
    
    public ScrubberDataSource getDataSource() {
        return _dataSource;
    }
    
    public void setDataSource(ScrubberDataSource dataSource) {
        _dataSource = dataSource; // dynamically resolved so does not require update to be called.
    }
}
