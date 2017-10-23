package com.thizzer.jtouchbar.awt;

import java.awt.Component;

public class AWTUtils {
	
	private static final String COMPONENT_METHOD_GET_PEER = "getPeer";
	private static final String COMPONENT_METHOD_GET_PLATFORM_WINDOW = "getPlatformWindow";
	private static final String COMPONENT_METHOD_GET_CONTENT_VIEW = "getContentView";
	private static final String COMPONENT_METHOD_GET_AWT_VIEW = "getAWTView";
	
	public static long getViewPointer(Component component) throws RuntimeException {
		if(component == null) {
			return 0;
		}
		
		try {
	        Object peer = Component.class.getMethod(COMPONENT_METHOD_GET_PEER).invoke(component);
	        Object window = peer.getClass().getMethod(COMPONENT_METHOD_GET_PLATFORM_WINDOW).invoke(peer);
	        Object view = window.getClass().getMethod(COMPONENT_METHOD_GET_CONTENT_VIEW).invoke(window);
	        
	        return (Long) view.getClass().getMethod(COMPONENT_METHOD_GET_AWT_VIEW).invoke(view);
	    } 
	    catch (Exception exception) {
	        throw new RuntimeException(exception);
	    }
	}
}
