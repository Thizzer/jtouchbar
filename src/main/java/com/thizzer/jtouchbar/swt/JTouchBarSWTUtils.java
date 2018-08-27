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

import com.thizzer.jtouchbar.JTouchBar;
import com.thizzer.jtouchbar.JTouchBarJNI;

public class JTouchBarSWTUtils {
	
	public static void show(JTouchBar jTouchbar, Shell shell) {
		long viewPointer = getViewPointer(shell);
		JTouchBarJNI.setTouchBar0(viewPointer, jTouchbar);
	}
	
	public static void hide(Shell shell) {
		if(shell == null) {
			return;
		}
		long viewPointer = getViewPointer(shell);
		JTouchBarJNI.setTouchBar0(viewPointer, null);
	}
	
	private static long getViewPointer(Shell shell) {
		if(shell == null || shell.view == null) {
			return 0L;
		}
		
		return shell.view.id;
	}
}
