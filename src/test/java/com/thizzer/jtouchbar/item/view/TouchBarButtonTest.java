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
package com.thizzer.jtouchbar.item.view;

import com.thizzer.jtouchbar.item.view.action.TouchBarViewAction;
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class TouchBarButtonTest {
	private static final long TIMEOUT_TIME = 3L;
	private static final TimeUnit TIMEOUT_TIMEUNIT = TimeUnit.SECONDS;

	@Test
	public void testIsEnabledNoAction() {
		final TouchBarButton touchBarButton = new TouchBarButton();

		Assert.assertTrue(touchBarButton.isEnabled());
	}

	@Test
	public void testIsEnabledWithEnabledAction() {
		final TouchBarButton touchBarButton = new TouchBarButton();
		final TouchBarViewAction touchBarButtonActionMock = Mockito.mock(TouchBarViewAction.class);

		Mockito.when(touchBarButtonActionMock.isEnabled()).thenReturn(true);

		touchBarButton.setAction(touchBarButtonActionMock);

		Assert.assertTrue(touchBarButton.isEnabled());

		Mockito.verify(touchBarButtonActionMock).isEnabled();
	}

	@Test
	public void testIsEnabledWithDisabledAction() {
		final TouchBarButton touchBarButton = new TouchBarButton();
		final TouchBarViewAction touchBarButtonActionMock = Mockito.mock(TouchBarViewAction.class);

		Mockito.when(touchBarButtonActionMock.isEnabled()).thenReturn(false);

		touchBarButton.setAction(touchBarButtonActionMock);

		Assert.assertFalse(touchBarButton.isEnabled());

		Mockito.verify(touchBarButtonActionMock).isEnabled();
	}

	@Test
	public void testFireActionStateChanged() throws Exception {
		final TouchBarButton touchBarButton = new TouchBarButton();
		final TouchBarViewAction touchBarButtonActionMock = Mockito.mock(TouchBarViewAction.class);
		final CountDownLatch latch = new CountDownLatch(1);

		touchBarButton.setAction(touchBarButtonActionMock);
		touchBarButton.addObserver((observable, argument) -> latch.countDown());

		touchBarButton.fireActionStateChanged();

		latch.await(TIMEOUT_TIME, TIMEOUT_TIMEUNIT);

		Assert.assertTrue("Update not called!", latch.getCount() == 0);
	}

	@Test
	public void testFireActionStateChangedNoAction() throws Exception {
		final TouchBarButton touchBarButton = new TouchBarButton();
		final TouchBarViewAction touchBarButtonActionMock = Mockito.mock(TouchBarViewAction.class);
		final CountDownLatch latch = new CountDownLatch(1);

		touchBarButton.addObserver((observable, argument) -> latch.countDown());

		touchBarButton.fireActionStateChanged();

		latch.await(TIMEOUT_TIME, TIMEOUT_TIMEUNIT);

		Assert.assertTrue("Update called!", latch.getCount() == 1);
	}
}
