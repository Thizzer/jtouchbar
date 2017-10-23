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
#import <Cocoa/Cocoa.h>

#import "JavaTouchBar.h"
#import "JavaTouchBarItem.h"

@interface JavaTouchBarResponder : NSResponder <NSTouchBarDelegate>
{
    NSTouchBar *_touchBar;
}

@property (nonatomic,retain) JavaTouchBar* jTouchBar;

-(instancetype)initWithWindow:(NSWindow*)window andJavaTouchBar:(JavaTouchBar*)jTouchBar;

@end
