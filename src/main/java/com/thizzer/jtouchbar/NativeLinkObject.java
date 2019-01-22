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
