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
package com.thizzer.jtouchbar.swt;

import static org.junit.Assert.assertNotNull;

import org.eclipse.swt.layout.FillLayout;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;
import org.junit.Before;
import org.junit.Test;

import com.thizzer.jtouchbar.JTouchBar;
import com.thizzer.jtouchbar.JTouchBarTestUtils;

public class JTouchBarSWTTest {

	@Before
	public void setup() {
		Display.getDefault();
	}
	
	@Test
	public void test() {
		JTouchBar jTouchBar = JTouchBarTestUtils.constructTouchBar();
		assertNotNull(jTouchBar);
		
		Display display = Display.getCurrent();

        Shell shell = new Shell(display);
        shell.setLayout(new FillLayout());

        shell.open();
        
        jTouchBar.enableForShell( shell );
        
        while (!shell.isDisposed()) {
            if (!display.readAndDispatch()) {
                display.sleep();
                break;
            }
        }
        
        display.dispose();
	}

}
