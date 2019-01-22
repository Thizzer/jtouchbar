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

public class ImagePosition {

	// The cell doesn’t display an image.
	public static final int NO = 0;
	
	// The cell displays an image, but not a title. 
	public static final int ONLY = 1;
	
	// The image is to the left of the title.
	public static final int LEFT = 2;
	
	// The image is to the right of the title.
	public static final int RIGHT = 3;
	
	// The image is below the title.
	public static final int BELOW = 4;
	
	// The image is above the title.
	public static final int ABOVE = 5;
	
	// The image overlaps the title.
	public static final int OVERLAPS = 6;
	
}
