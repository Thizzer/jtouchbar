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
