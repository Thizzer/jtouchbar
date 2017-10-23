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
#import "JavaTouchBarResponder.h"

@implementation JavaTouchBarResponder

-(instancetype)initWithWindow:(NSWindow*)window andJavaTouchBar:(JavaTouchBar*)jTouchBar;
{
    if( ( self = [super init] ) )
    {
        self.jTouchBar = jTouchBar;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.nextResponder = window.nextResponder;
            window.nextResponder = self;
            
            if(@available(macOS 10_12_2, *)) {
                window.touchBar = [self makeTouchBar];
            }
            else {
                // TODO WARN USER/DEVELOPER
            }
        });
    }
    
    return self;
}

-(NSTouchBar *) makeTouchBar {
    _touchBar = [_jTouchBar createNSTouchBar];
    _touchBar.delegate = self;
    
    return _touchBar;
}

-(NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    for(JavaTouchBarItem *item in [self.jTouchBar getTouchBarItems]) {
        NSString *itemIdentifier = [item getIdentifier];
        if( [itemIdentifier isEqualToString:identifier]) {
            return [item getTouchBarItem];
        }
    }
    
    return nil;
}

@end
