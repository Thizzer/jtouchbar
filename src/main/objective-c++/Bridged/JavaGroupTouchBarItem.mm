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
#import "JavaGroupTouchBarItem.h"

#include <jni.h>
#include <string>

#include <Cocoa/Cocoa.h>

#import "JNIContext.h"
#import "JTouchBarUtils.h"

#import "JavaTouchBar.h"

@interface JavaGroupTouchBarItem() {
    NSGroupTouchBarItem *_touchBarItem;
    
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
        
        jobject groupTouchBar = JNIContext::CallObjectMethod(env, self.javaRepr, "getGroupTouchBar", "com/thizzer/jtouchbar/JTouchBar");
        
        _jTouchBar = [[JavaTouchBar alloc] init];
        [_jTouchBar setJavaRepr:groupTouchBar];
        
        _touchBarItem = [[NSGroupTouchBarItem alloc] initWithIdentifier:identifier];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar = [_jTouchBar createNSTouchBar];
        ((NSGroupTouchBarItem*)_touchBarItem).groupTouchBar.delegate = self;
        
        env->DeleteLocalRef(groupTouchBar);
    }
    
    return _touchBarItem;
}

-(NSTouchBarItem *)touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier {
    return [JTouchBarUtils touchBar:touchBar makeItemForIdentifier:identifier usingJavaTouchBar:_jTouchBar];
}

@end
