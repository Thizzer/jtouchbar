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
package com.thizzer.jtouchbar.awt;

import static org.junit.Assert.assertNotNull;

import javax.swing.JFrame;

import org.junit.Test;

import com.thizzer.jtouchbar.JTouchBar;
import com.thizzer.jtouchbar.JTouchBarTestUtils;

public class JTouchBarAWTTest {

	@Test
	public void test() {
		JTouchBar jTouchBar = JTouchBarTestUtils.constructTouchBar();
		assertNotNull(jTouchBar);
		
		JFrame.setDefaultLookAndFeelDecorated(true);
		
        final JFrame frame = new JFrame("JTouchBar");
        frame.pack();
        frame.setVisible(true);

        jTouchBar.show(frame);
	}

}
