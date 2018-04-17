package com.thizzer.jtouchbar;

import java.util.Observable;

public abstract class NativeLinkObject extends Observable {

	/**
	 * 
	 */
	
	private long _nativeInstancePointer = 0L;
	
	protected long getNativeInstancePointer() {
		return _nativeInstancePointer;
	}
	
	void setNativeInstancePointer(long nativeInstancePointer) {
		_nativeInstancePointer = nativeInstancePointer;
	}
}
