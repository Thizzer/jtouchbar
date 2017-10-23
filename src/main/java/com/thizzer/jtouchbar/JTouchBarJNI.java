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
package com.thizzer.jtouchbar;

import java.awt.Component;
import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;

class JTouchBarJNI {

	static {
		try {
			System.loadLibrary("JTouchBar");
		}
		catch(UnsatisfiedLinkError e) {	
			loadLibraryFromJar("/lib/libJTouchBar.dylib");
		}
	}
	
	static native void setTouchBar0(long viewPointer, JTouchBar touchBar);
	
	private static long getAWTViewPointer(Component c) {
	    try {
	        Object componentPeer = c.getClass().getMethod("getPeer").invoke(c);
	        Object platformWindow = componentPeer.getClass().getMethod("getPlatformWindow").invoke(componentPeer);
	        Object contentView = platformWindow.getClass().getMethod("getContentView").invoke(platformWindow);
	        return (Long) contentView.getClass().getMethod("getAWTView").invoke(contentView);
	    } 
	    catch (Exception exception) {
	        throw new RuntimeException(exception);
	    }
	}
	
	private static void loadLibraryFromJar(String path) throws UnsatisfiedLinkError {
		try (InputStream inputStream = JTouchBarJNI.class.getResourceAsStream(path)) {
			File tempLib = File.createTempFile(path, "");
			
		    byte[] buffer = new byte[1024];
		    int read = -1;
		    
		    try(FileOutputStream fileOutputStream = new FileOutputStream(tempLib)) {
			    	while((read = inputStream.read(buffer)) != -1) {
			    		fileOutputStream.write(buffer, 0, read);
			    	}
		    }
		    
		    System.load(tempLib.getAbsolutePath());
		}
		catch(Exception e) {
			throw new UnsatisfiedLinkError("Unable to open "+ path +" from jar file.");
		}
	}
}
