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
package com.thizzer.jtouchbar.swing;

import com.thizzer.jtouchbar.item.view.TouchBarButton;
import com.thizzer.jtouchbar.item.view.TouchBarView;
import com.thizzer.jtouchbar.item.view.action.TouchBarViewAction;

import javax.swing.Action;
import javax.swing.SwingUtilities;
import java.awt.event.ActionEvent;
import java.beans.PropertyChangeListener;
import java.util.Objects;

/**
 * A class that wraps a {@link TouchBarViewAction} such that it knows when a {@link TouchBarButton} needs to be
 * enabled/disabled.
 */
public class SwingTouchBarActionDelegate implements TouchBarViewAction {
	private static final String PROPERTY_NAME_ENABLED = "enabled";

	private final Action action;
	private final PropertyChangeListener propertyChangeListener;

	public SwingTouchBarActionDelegate(final Action action, final TouchBarButton touchBarButton) {
		Objects.requireNonNull(action, "action");
		Objects.requireNonNull(touchBarButton, "touchBarButton");

		this.action = action;
		this.propertyChangeListener = event -> {
			if (PROPERTY_NAME_ENABLED.equals(event.getPropertyName())) {
				touchBarButton.fireActionStateChanged();
			}
		};

		this.action.addPropertyChangeListener(this.propertyChangeListener);
	}

	public void destroy() {
		this.action.removePropertyChangeListener(this.propertyChangeListener);
	}

	protected boolean isOnEDT() {
		return SwingUtilities.isEventDispatchThread();
	}

	protected ActionEvent getActionEvent() {
		return new ActionEvent(this, 0, null);
	}

	@Override
	public void onCall(final TouchBarView view) {
		if (isOnEDT()) {
			callAction();
		} else {
			SwingUtilities.invokeLater(this::callAction);
		}
	}

	private void callAction() {
		this.action.actionPerformed(getActionEvent());
	}

	@Override
	public boolean isEnabled() {
		return this.action.isEnabled();
	}
}
