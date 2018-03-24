package com.thizzer.jtouchbar;

import com.thizzer.jtouchbar.item.view.TouchBarButton;
import com.thizzer.jtouchbar.item.view.TouchBarView;
import com.thizzer.jtouchbar.swing.SwingTouchBarActionWrapper;
import org.junit.Assert;
import org.junit.Ignore;
import org.junit.Test;
import org.mockito.Mockito;

import javax.swing.AbstractAction;
import javax.swing.Action;
import java.awt.event.ActionEvent;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;

public class SwingTouchBarActionWrapperTest {
	private static final long TIMEOUT_TIME = 3L;
	private static final TimeUnit TIMEOUT_TIMEUNIT = TimeUnit.SECONDS;

	@Test(expected = NullPointerException.class)
	public void testCreateNullAction() {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);

		new SwingTouchBarActionWrapper(null, touchBarButtonMock);
	}

	@Test(expected = NullPointerException.class)
	public void testCreateNullButton() {
		final Action actionMock = Mockito.mock(Action.class);

		new SwingTouchBarActionWrapper(actionMock, null);
	}

	@Test
	public void testTouchBarButtonActionStateChangeFired() throws Exception {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);

		final Action action = new AbstractAction() {
			@Override
			public void actionPerformed(final ActionEvent event) {
				// nothing to do
			}
		};

		new SwingTouchBarActionWrapper(action, touchBarButtonMock);

		action.setEnabled(false);

		Mockito.verify(touchBarButtonMock).fireActionStateChanged();
	}

	@Test
	public void testTouchBarButtonActionStateChangeNotFiredAfterDestroyed() throws Exception {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);

		final Action action = new AbstractAction() {
			@Override
			public void actionPerformed(final ActionEvent event) {
				// nothing to do
			}
		};

		final SwingTouchBarActionWrapper swingTouchBarActionWrapper =
				new SwingTouchBarActionWrapper(action, touchBarButtonMock);

		swingTouchBarActionWrapper.destroy();

		action.setEnabled(false);

		Mockito.verify(touchBarButtonMock, Mockito.never()).fireActionStateChanged();
	}

	@Test
	public void testActionCalled() throws Exception {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);
		final TouchBarView touchBarViewMock = Mockito.mock(TouchBarView.class);
		final Action actionMock = Mockito.mock(Action.class);

		final SwingTouchBarActionWrapper swingTouchBarActionWrapper =
				new SwingTouchBarActionWrapper(actionMock, touchBarButtonMock) {
					@Override
					protected boolean isOnEDT() {
						return true;
					}

					@Override
					protected ActionEvent getActionEvent() {
						return null;
					}
				};

		swingTouchBarActionWrapper.onCall(touchBarViewMock);

		Mockito.verify(actionMock).actionPerformed(Mockito.any(ActionEvent.class));
	}

	@Test
	public void testIsEnabled() {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);

		final Action action = new AbstractAction() {
			@Override
			public void actionPerformed(final ActionEvent event) {
				// nothing to do
			}
		};

		final SwingTouchBarActionWrapper swingTouchBarActionWrapper =
				new SwingTouchBarActionWrapper(action, touchBarButtonMock);

		action.setEnabled(false);

		Assert.assertFalse(swingTouchBarActionWrapper.isEnabled());

		action.setEnabled(true);

		Assert.assertTrue(swingTouchBarActionWrapper.isEnabled());
	}
}
