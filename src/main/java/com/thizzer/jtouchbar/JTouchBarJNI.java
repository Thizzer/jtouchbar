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
package com.thizzer.jtouchbar;

import java.awt.Component;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;


public class JTouchBarJNI {

	static {
		try {
			System.loadLibrary("JTouchBar");
		}
		catch(UnsatisfiedLinkError e) {	
			loadLibraryFromJar("/lib/libJTouchBar.dylib");
		}
	}
	
	public static native void setTouchBar0(long viewPointer, JTouchBar touchBar);
	
	public static native void updateTouchBarItem(long nativeInstancePointer);
	
	public static native void callObjectSelector(long nativeInstancePointer, String selector, boolean onMainThread);
	
	public static native int callIntObjectSelector(long nativeInstancePointer, String selector);
	
	public static native long getAWTViewPointer0(Component c);
	
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
