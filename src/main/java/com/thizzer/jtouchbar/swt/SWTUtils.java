/**
 * JTouchBar
 *
 * Copyright (c) 2018 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
package com.thizzer.jtouchbar.swt;

import org.eclipse.swt.widgets.Shell;

public class SWTUtils {

	public static long getViewPointer( Shell shell ) {
		if(shell == null || shell.view == null) {
			return 0L;
		}
		
		return shell.view.id;
	}
}
