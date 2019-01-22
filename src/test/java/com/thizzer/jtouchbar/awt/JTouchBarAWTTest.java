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
package com.thizzer.jtouchbar.awt;

import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;

import javax.swing.JFrame;

import org.junit.Test;

import com.thizzer.jtouchbar.JTouchBar;
import com.thizzer.jtouchbar.JTouchBarTestUtils;

public class JTouchBarAWTTest {

	@Test
	public void test() {
		new Thread(new Runnable() {
			
			 @Override
	         public void run() {
				 testTouchBarAWT();
			 }
		})
		.start();
		
		try {
			Thread.sleep(1000);
		} 
        catch (InterruptedException ignored) {
        	assertTrue(false);
        }
	}
	
	public void testTouchBarAWT() {
		JTouchBar jTouchBar = JTouchBarTestUtils.constructTouchBar();
		assertNotNull(jTouchBar);
		
		JFrame.setDefaultLookAndFeelDecorated(true);
		
        final JFrame frame = new JFrame("JTouchBar");
        frame.pack();
        frame.setVisible(true);

        jTouchBar.show(frame);
	}

}
