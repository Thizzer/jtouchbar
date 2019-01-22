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

public abstract interface ScrubberActionListener {

    void didSelectItemAtIndex(TouchBarScrubber scrubber, long index);
}
