/**
 * JTouchBar
 *
 * Copyright (c) 2017 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author      M. ten Veldhuis
 */
#import "JavaTouchBar.h"

#include <jni.h>
#include "JNIContext.h"

@interface JavaTouchBar() {
    NSString *_customizationIdentifier;
    NSString *_principalItemIdentifier;
    NSArray<JavaTouchBarItem*> *_jTouchBarItems;
}

-(NSString*) getCustomizationIdentifier:(JNIEnv*)env reload:(BOOL)reload;
-(NSString*) getPrincipalItemIdentifier:(JNIEnv*)env reload:(BOOL)reload;

-(NSArray<JavaTouchBarItem*>*) getTouchBarItems:(JNIEnv*)env reload:(BOOL)reload;
@end

@implementation JavaTouchBar

-(NSString*) getCustomizationIdentifier:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        std::string customizationIdentifier = JNIContext::CallStringMethod(env, _javaRepr, "getCustomizationIdentifier");
        _customizationIdentifier = [NSString stringWithUTF8String:customizationIdentifier.c_str()];
    }
    
    return _customizationIdentifier;
}

-(NSString*) getCustomizationIdentifier {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    return [self getCustomizationIdentifier:env reload:TRUE];
}

-(NSString*) getPrincipalItemIdentifier:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        std::string principalItemIdentifier = JNIContext::CallStringMethod(env, _javaRepr, "getPrincipalItemIdentifier");
        _principalItemIdentifier = [NSString stringWithUTF8String:principalItemIdentifier.c_str()];
    }
    
    return _principalItemIdentifier;
}

-(NSString*) getPrincipalItemIdentifier {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    return [self getPrincipalItemIdentifier:env reload:TRUE];
}

-(NSArray<JavaTouchBarItem*>*) getTouchBarItems:(JNIEnv*)env reload:(BOOL)reload {
    if(_jTouchBarItems == nil || [_jTouchBarItems count] == 0 || reload) {
        jobject touchBarItems = JNIContext::CallObjectMethod(env, _javaRepr, "getItems", "java/util/List");
        jobject touchBarItemIterator = JNIContext::CallObjectMethod(env, touchBarItems, "iterator", "java/util/Iterator");
    
        jmethodID nextMid = env->GetMethodID(env->GetObjectClass(touchBarItemIterator), "next", "()Ljava/lang/Object;");
        jmethodID hasNextMid = env->GetMethodID(env->GetObjectClass(touchBarItemIterator), "hasNext", "()Z");

        _jTouchBarItems = [[NSMutableArray alloc] init];
        while (env->CallBooleanMethod(touchBarItemIterator, hasNextMid)) {
            jobject touchBarItem = env->CallObjectMethod(touchBarItemIterator, nextMid);
            
            JavaTouchBarItem *item = nil;
            
            jclass groupItemCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/GroupTouchBarItem");
            if(env->IsInstanceOf(touchBarItem, groupItemCls)) {
                item = [[JavaGroupTouchBarItem alloc] init];
                item.javaRepr = touchBarItem;
            }
            else {
                item = [[JavaTouchBarItem alloc] init];
                item.javaRepr = touchBarItem;
            }
            
            [((NSMutableArray*)_jTouchBarItems) addObject:item];
        }
    }
    
    return _jTouchBarItems;
}

-(NSArray<JavaTouchBarItem*>*) getTouchBarItems {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    return [self getTouchBarItems:env reload:FALSE];
}

-(NSTouchBar*) createNSTouchBar {
    NSTouchBar *touchBar = [[NSTouchBar alloc] init];
    
    NSMutableArray<NSString*>* defaultIdentifiers = [[NSMutableArray alloc] init];
    NSMutableArray<NSString*>* customizableIdentifiers = [[NSMutableArray alloc] init];
    
    for(JavaTouchBarItem *item in [self getTouchBarItems]) {
        NSString *identifier = [item getIdentifier];
        [defaultIdentifiers addObject:identifier];
        
        if([item isCustomizationAllowed]){
            [customizableIdentifiers addObject:identifier];
        }
    }
    
    touchBar.defaultItemIdentifiers = defaultIdentifiers;
    touchBar.customizationAllowedItemIdentifiers = customizableIdentifiers;
    
    touchBar.customizationIdentifier = [self getCustomizationIdentifier];
    touchBar.principalItemIdentifier = [self getPrincipalItemIdentifier];
    
    return touchBar;
}

-(void) setJavaRepr:(jobject)javaRepr {
    JNIEnv *env; JNIContext context(&env);
    if(_javaRepr != NULL) {
        env->DeleteGlobalRef(_javaRepr);
    }
    
    _javaRepr = env->NewGlobalRef(javaRepr);
}

-(void)dealloc {
    [self setJavaRepr:NULL];
}

@end
