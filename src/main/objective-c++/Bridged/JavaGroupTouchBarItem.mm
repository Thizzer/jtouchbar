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
#import "JavaTouchBarItem.h"

#include <Cocoa/Cocoa.h>

#include <jni.h>
#include <string>

#include "JNIContext.h"
#include "JNIUtils.h"

#include "JavaTouchBar.h"

@interface JavaGroupTouchBarItem() {
    NSTouchBarItem *_touchBarItem;
    
    JavaTouchBar *_jTouchBar;
    NSTouchBar *_groupTouchBar;
}

@end

@implementation JavaGroupTouchBarItem

-(NSTouchBarItem*) getTouchBarItem {
    if(self.javaRepr == NULL) {
        return nil;
    }
    
    if(_touchBarItem == nil) {
        JNIEnv *env; JNIContext context(&env);
        
        NSString *identifier = [super getIdentifier:env reload:TRUE];
        
        jobject groupTouchBar = JNIUtils::CallObjectMethod(env, self.javaRepr, "getGroupTouchBar", "com/thizzer/jtouchbar/JTouchBar");
        
        _jTouchBar = [[JavaTouchBar alloc] init];
        [_jTouchBar setJavaRepr:groupTouchBar];
        
        _touchBarItem = [[NSGroupTouchBarItem alloc] initWithIdentifier:identifier];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar = [_jTouchBar createNSTouchBar];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar.delegate = self;
    }
    
    return _touchBarItem;
}

-(NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    for(JavaTouchBarItem *item in [_jTouchBar getTouchBarItems]) {
        NSString *itemIdentifier = [item getIdentifier];
        if( [itemIdentifier isEqualToString:identifier]) {
            return [item getTouchBarItem];
        }
    }
    
    return nil;
}

@end
