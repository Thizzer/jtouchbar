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
package com.thizzer.jtouchbar.item.view;

import java.util.Observable;

public abstract class TouchBarView extends Observable {
	
	void update() {
		setChanged();
		notifyObservers();
	}
}
