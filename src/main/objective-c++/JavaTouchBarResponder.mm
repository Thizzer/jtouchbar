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
#import "JavaTouchBarResponder.h"

#import "JTouchBarUtils.h"

@implementation JavaTouchBarResponder

-(void) setTouchBar:(JavaTouchBar *)jTouchBar window:(NSWindow*)window {
    self.jTouchBar = jTouchBar;
    
    // prepare touchbar, handling creation exceptions on the current thread.
    [self makeTouchBar];
    
    if(@available(macOS 10_12_2, *)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(self.jTouchBar == nil) {
                window.nextResponder = self.nextResponder;
            }
            else {
                self.nextResponder = window.nextResponder;
                window.nextResponder = self;
            }
            
            window.touchBar = [self makeTouchBar];
        });
    }
    else {
        // TODO WARN USER/DEVELOPER
    }
}

-(NSTouchBar *) makeTouchBar {
    if(_jTouchBar == nil) {
        return nil;
    }
    
    _touchBar = [_jTouchBar createNSTouchBar];
    if(_touchBar == nil) {
        return nil;
    }
    
    _touchBar.delegate = self;
    
    return _touchBar;
}

-(NSTouchBarItem *) touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    return [JTouchBarUtils touchBar:touchBar makeItemForIdentifier:identifier usingJavaTouchBar:_jTouchBar];
}

@end
