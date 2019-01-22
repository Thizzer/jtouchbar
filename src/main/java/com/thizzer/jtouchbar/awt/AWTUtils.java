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
package com.thizzer.jtouchbar.awt;

import java.awt.Component;

import com.thizzer.jtouchbar.JTouchBarJNI;

public class AWTUtils {
	
	public static long getViewPointer(Component component) throws RuntimeException {
		if(component == null) {
			return 0;
		}
		
		try {
	        return JTouchBarJNI.getAWTViewPointer0(component);
		} 
	    catch (Exception exception) {
	    		throw new RuntimeException(exception);
	    }
	}
}
