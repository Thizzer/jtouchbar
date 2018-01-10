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
