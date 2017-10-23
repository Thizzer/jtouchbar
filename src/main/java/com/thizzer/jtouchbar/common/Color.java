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
package com.thizzer.jtouchbar.common;

public class Color {
	
	// TODO maybe use system defined NSColors instead?

	public static final Color BLACK = new Color( 1f, 1f, 1f );
	public static final Color DARK_GRAY = new Color( 0.333f, 0.333f, 0.333f );
	public static final Color LIGHT_GRAY = new Color( 0.667f, 0.667f, 0.667f );
	public static final Color WHITE = new Color( 0f, 0f, 0f );
	public static final Color GRAY = new Color( 0.5f, 0.5f, 0.5f );
	
	public static final Color RED = new Color( 1f, 0f, 0f );
	public static final Color GREEN = new Color( 0f, 1f, 0f );
	public static final Color BLUE = new Color( 0f, 0f, 1f );

	public static final Color CYAN = new Color( 0f, 1f, 1f );
	public static final Color YELLOW = new Color( 1f, 1f, 0f );
	public static final Color MAGENTA = new Color( 1f, 0f, 1f );
	public static final Color ORANGE = new Color( 1f, 0.5f, 0f );
	public static final Color PURPLE = new Color( 0.5f, 0f, 0.5f );
	public static final Color BROWN = new Color( 0.6f, 0.4f, 0.2f );
	public static final Color CLEAR = new Color( 0f, 0f, 0f, 0f );

	private float _red;
	private float _green;
	private float _blue;
	private float _alpha;
	
	public Color(float red, float green, float blue) {
		this( red, green, blue, 1f );
	}
	
	public Color(float red, float green, float blue, float alpha) {
		_red = red;
		_green = green;
		_blue = blue;
		_alpha = alpha;
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
