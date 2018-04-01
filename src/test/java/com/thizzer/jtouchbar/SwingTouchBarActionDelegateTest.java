package com.thizzer.jtouchbar;

import com.thizzer.jtouchbar.item.view.TouchBarButton;
import com.thizzer.jtouchbar.item.view.TouchBarView;
import com.thizzer.jtouchbar.swing.SwingTouchBarActionDelegate;
import org.junit.Assert;
import org.junit.Test;
import org.mockito.Mockito;

import javax.swing.AbstractAction;
import javax.swing.Action;
import java.awt.event.ActionEvent;
import java.util.concurrent.TimeUnit;

public class SwingTouchBarActionDelegateTest {
	private static final long TIMEOUT_TIME = 3L;
	private static final TimeUnit TIMEOUT_TIMEUNIT = TimeUnit.SECONDS;

	@Test(expected = NullPointerException.class)
	public void testCreateNullAction() {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);

		new SwingTouchBarActionDelegate(null, touchBarButtonMock);
	}

	@Test(expected = NullPointerException.class)
	public void testCreateNullButton() {
		final Action actionMock = Mockito.mock(Action.class);

		new SwingTouchBarActionDelegate(actionMock, null);
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

		new SwingTouchBarActionDelegate(action, touchBarButtonMock);

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

		final SwingTouchBarActionDelegate swingTouchBarActionDelegate =
				new SwingTouchBarActionDelegate(action, touchBarButtonMock);

		swingTouchBarActionDelegate.destroy();

		action.setEnabled(false);

		Mockito.verify(touchBarButtonMock, Mockito.never()).fireActionStateChanged();
	}

	@Test
	public void testActionCalled() throws Exception {
		final TouchBarButton touchBarButtonMock = Mockito.mock(TouchBarButton.class);
		final TouchBarView touchBarViewMock = Mockito.mock(TouchBarView.class);
		final Action actionMock = Mockito.mock(Action.class);

		final SwingTouchBarActionDelegate swingTouchBarActionDelegate =
				new SwingTouchBarActionDelegate(actionMock, touchBarButtonMock) {
					@Override
					protected boolean isOnEDT() {
						return true;
					}

					@Override
					protected ActionEvent getActionEvent() {
						return null;
					}
				};

		swingTouchBarActionDelegate.onCall(touchBarViewMock);

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

		final SwingTouchBarActionDelegate swingTouchBarActionDelegate =
				new SwingTouchBarActionDelegate(action, touchBarButtonMock);

		action.setEnabled(false);

		Assert.assertFalse(swingTouchBarActionDelegate.isEnabled());

		action.setEnabled(true);

		Assert.assertTrue(swingTouchBarActionDelegate.isEnabled());
	}
}
