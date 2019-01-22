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
package com.thizzer.jtouchbar.common;

public class Color {
	
	public static final Color BLACK = new Color("blackColor");
	public static final Color DARK_GRAY = new Color("darkGrayColor");
	public static final Color LIGHT_GRAY = new Color("lightGrayColor");
	public static final Color WHITE = new Color("whiteColor");
	public static final Color GRAY = new Color("grayColor");
	
	public static final Color RED = new Color("redColor");
	public static final Color GREEN = new Color("greenColor");
	public static final Color BLUE = new Color("blueColor");

	public static final Color CYAN = new Color("cyanColor");
	public static final Color YELLOW = new Color("yellowColor");
	public static final Color MAGENTA = new Color("magentaColor");
	public static final Color ORANGE = new Color("orangeColor");
	public static final Color PURPLE = new Color("purpleColor");
	public static final Color BROWN = new Color("brownColor");
	public static final Color CLEAR = new Color("clearColor");

	public static final Color CONTROL_SHADOW = new Color("controlShadowColor");
	public static final Color CONTROL_DARK_SHADOW = new Color("controlDarkShadowColor");
	public static final Color CONTROL_COLOR = new Color("controlColor");
	public static final Color CONTROL_HIGHLIGHT = new Color("controlHighlightColor");
	public static final Color CONTROL_LIGHT_HIGHLIGHT = new Color("controlLightHighlightColor");
	public static final Color CONTROL_TEXT = new Color("controlTextColor");
	public static final Color CONTROL_BACKGROUND = new Color("controlBackgroundColor");
	
	public static final Color SELECTED_CONTROL = new Color("selectedControlColor");
	public static final Color SECONDARY_SELECTED_CONTROL = new Color("secondarySelectedControlColor");
	public static final Color SELECTED_CONTROL_TEXT = new Color("selectedControlTextColor");
	public static final Color DISABLED_CONTROL_TEXT = new Color("disabledControlTextColor");
	public static final Color TEXT = new Color("textColor");
	public static final Color TEXT_BACKGROUND = new Color("textBackgroundColor");
	public static final Color SELECTED_TEXT = new Color("selectedTextColor");
	public static final Color SELECTED_TEXT_BACKGROUND = new Color("selectedTextBackgroundColor");
	public static final Color GRID_COLOR = new Color("gridColor");
	public static final Color KEYBOARD_FOCUS_INDICATOR = new Color("keyboardFocusIndicatorColor");
	public static final Color WINDOW_BACKGROUND = new Color("windowBackgroundColor");
	public static final Color UNDERPAGE_BACKGROUND = new Color("underPageBackgroundColor");
	
	public static final Color LABEL = new Color("labelColor");
	public static final Color SECONDARY_LABEL = new Color("secondaryLabelColor");
	public static final Color TERTIARY_LABEL = new Color("tertiaryLabelColor");
	public static final Color QUATERNARY_LABEL = new Color("quaternaryLabelColor");
	
	public static final Color SCROLLBAR = new Color("scrollBarColor");
	public static final Color KNOB = new Color("knobColor");
	public static final Color SELECTED_KNOB = new Color("selectedKnobColor");
	
	public static final Color WINDOW_FRAME = new Color("windowFrameColor");
	public static final Color WINDOW_FRAME_TEXT = new Color("windowFrameTextColor");
	
	public static final Color SELECTED_MENU_ITEM = new Color("selectedMenuItemColor");
	public static final Color SELECTED_MENU_ITEM_TEXT = new Color("selectedMenuItemTextColor");
	
	public static final Color HIGHLIGHT = new Color("highlightColor");
	public static final Color SHADOW = new Color("shadowColor");
	
	public static final Color HEADER = new Color("headerColor");
	public static final Color HEADER_TEXT = new Color("headerTextColor");
	
	public static final Color ALTERNATE_SELECTED_CONTROL = new Color("alternateSelectedControlColor");
	public static final Color ALTERNATE_SELECTED_CONTROL_TEXT = new Color("alternateSelectedControlTextColor");
	
	public static final Color SCRUBBER_TEXTURED_BACKGROUND = new Color("scrubberTexturedBackgroundColor");
	
	public static final Color SYSTEM_RED = new Color("systemRedColor");
	public static final Color SYSTEM_GREEN = new Color("systemGreenColor");
	public static final Color SYSTEM_BLUE = new Color("systemBlueColor");
	public static final Color SYSTEM_ORANGE = new Color("systemOrangeColor");
	public static final Color SYSTEM_YELLOW = new Color("systemYellowColor");
	public static final Color SYSTEM_BROWN = new Color("systemBrownColor");
	public static final Color SYSTEM_PINK = new Color("systemPinkColor");
	public static final Color SYSTEM_PURPLE = new Color("systemPurpleColor");
	public static final Color SYSTEM_GRAY = new Color("systemGrayColor");
		
	private String _nsColorKey;
	
	private float _red;
	private float _green;
	private float _blue;
	private float _alpha;
	
	public Color(String nsColorKey) {
		_nsColorKey = nsColorKey;
	}
	
	public Color(float red, float green, float blue) {
		this( red, green, blue, 1f );
	}
	
	public Color(float red, float green, float blue, float alpha) {
		_red = red;
		_green = green;
		_blue = blue;
		_alpha = alpha;
	}
		
	public String getNsColorKey() {
		return _nsColorKey;
	}

	public void setNsColorKey(String nsColorKey) {
		_nsColorKey = nsColorKey;
	}

	public float getRed() {
		return _red;
	}
	
	public void setRed(float red) {
		_red = red;
	}
	
	public float getGreen() {
		return _green;
	}
	
	public void setGreen(float green) {
		_green = green;
	}
	
	public float getBlue() {
		return _blue;
	}
	
	public void setBlue(float blue) {
		_blue = blue;
	}
	
	public float getAlpha() {
		return _alpha;
	}
	
	public void setAlpha(float alpha) {
		_alpha = alpha;
	}
}
