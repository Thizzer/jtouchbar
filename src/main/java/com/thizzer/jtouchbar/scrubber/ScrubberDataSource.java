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
package com.thizzer.jtouchbar.scrubber;

import com.thizzer.jtouchbar.item.view.TouchBarScrubber;
import com.thizzer.jtouchbar.scrubber.view.ScrubberView;

public interface ScrubberDataSource {

	int getNumberOfItems(TouchBarScrubber scrubber);
    
    ScrubberView getViewForIndex(TouchBarScrubber scrubber, long index);
}
