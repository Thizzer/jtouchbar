package com.thizzer.jtouchbar.javafx;

import javafx.stage.Window;

import com.thizzer.jtouchbar.JTouchBarJNI;

public class JavaFXUtils {
	
	public static long getViewPointer(Window window) throws RuntimeException {
		if(window == null) {
			return 0;
		}
		
		try {
	        return JTouchBarJNI.getJavaFXViewPointer0(window);
		} 
	    catch (Exception exception) {
	    	throw new RuntimeException(exception);
	    }
	}
}
