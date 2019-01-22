/**
 * JTouchBar
 *
 * Copyright (c) 2018 - 2019 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author      M. ten Veldhuis
 */
#import "JTouchBarBridge.h"

#import <Cocoa/Cocoa.h>
#import <JavaVM/JavaVM.h>

#include "JNIContext.h"
#include "JavaTouchBarResponder.h"

static NSMapTable<NSWindow*, JavaTouchBarResponder*> *windowMapping = [NSMapTable weakToStrongObjectsMapTable];

@implementation JTouchBarBridge

+(void) setTouchBar:(JNIEnv*)env cls:(jclass)cls viewOrWindowPointerValue:(long)viewOrWindowPointerValue touchBar:(jobject)touchBar {
    @try {
        if(viewOrWindowPointerValue == 0) {
            return;
        }
        
        void* viewOrWindowPointer = (void*) viewOrWindowPointerValue;
        NSObject* nsObjectPointer = (__bridge NSObject*) viewOrWindowPointer;
        if(nsObjectPointer == nil) {
            return;
        }
        
        NSWindow *nsWindow = nil;
        if([nsObjectPointer isKindOfClass:[NSView class]]) {
            NSView *nsView = (NSView*) nsObjectPointer;
            if(nsView == nil || ![nsView respondsToSelector:@selector(window)]) {
                return;
            }
            
            nsWindow = nsView.window;
        }
        else if([nsObjectPointer isKindOfClass:[NSWindow class]]) {
            nsWindow = (NSWindow*) nsObjectPointer;
        }
        else {
            return;
        }
        
        if(nsWindow == nil) {
            return;
        }
        
        JavaTouchBarResponder *jPreviousTouchBarResponder = [windowMapping objectForKey:nsWindow];
        if(jPreviousTouchBarResponder == nil && touchBar == nullptr) {
            return;
        }
        
        if(touchBar == nullptr) {
            [jPreviousTouchBarResponder setTouchBar:nil window:nsWindow];
            [windowMapping removeObjectForKey:nsWindow];
        }
        else {
            if(jPreviousTouchBarResponder != nil) {
                // ensure any old references get destroyed
                [jPreviousTouchBarResponder setTouchBar:nil window:nsWindow];
                [windowMapping removeObjectForKey:nsWindow];
            }
            
            JavaTouchBarResponder *jTouchBarResponder = [[JavaTouchBarResponder alloc] init];
            [windowMapping setObject:jTouchBarResponder forKey:nsWindow];
            
            JavaTouchBar *jTouchBar = [[JavaTouchBar alloc] init];
            jTouchBar.javaRepr = touchBar;
            
            [jTouchBarResponder setTouchBar:jTouchBar window:nsWindow];
        }
    }
    @catch(NSException* e) {
        JNIContext::ThrowJavaException(env, e);
    }
}

+(void) updateTouchBarItem:(JNIEnv*)env cls:(jclass)cls itemPointer:(long)itemPointer {
    @try {
        void* cItemPointer = (void*)itemPointer;
        if(cItemPointer == nullptr) {
            return;
        }
        
        JavaTouchBarItem *touchBarItem = (__bridge JavaTouchBarItem*) (cItemPointer);
        if(touchBarItem == nil) {
            return;
        }
        
        [touchBarItem update];
    }
    @catch(NSException* e) {
        JNIContext::ThrowJavaException(env, e);
    }
}

+(void) callObjectSelector:(JNIEnv*)env cls:(jclass)cls objectPointer:(long)objectPointer selector:(jstring)javaSelector onMainThread:(jboolean)onMainThread {
    @try {
        void* cItemPointer = (void*)objectPointer;
        if(cItemPointer == nullptr) {
            return;
        }
        
        NSObject *touchBarItem = (__bridge NSObject*) (cItemPointer);
        if(touchBarItem == nil) {
            return;
        }
        
        const char *charSelectorValue = env->GetStringUTFChars(javaSelector, 0);
        if(charSelectorValue == nullptr) {
            return;
        }
        
        NSString *selectorStr = [NSString stringWithUTF8String:charSelectorValue];
        env->ReleaseStringUTFChars(javaSelector, charSelectorValue);
        
        SEL selector = NSSelectorFromString(selectorStr);
        if(selectorStr != nil && [touchBarItem respondsToSelector:selector]) {
            if(onMainThread) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    ((void (*)(id, SEL))[touchBarItem methodForSelector:selector])(touchBarItem, selector);
                });
            }
            else {
                ((void (*)(id, SEL))[touchBarItem methodForSelector:selector])(touchBarItem, selector);
            }
        }
    }
    @catch(NSException* e) {
        JNIContext::ThrowJavaException(env, e);
    }
}

+(int) callIntObjectSelector:(JNIEnv*)env cls:(jclass)cls objectPointer:(long)objectPointer selector:(jstring)javaSelector {
    @try {
        void* cItemPointer = (void*)objectPointer;
        if(cItemPointer == nullptr) {
            return 0;
        }
        
        NSObject *touchBarItem = (__bridge NSObject*) (cItemPointer);
        if(touchBarItem == nil) {
            return 0;
        }
        
        const char *charSelectorValue = env->GetStringUTFChars(javaSelector, 0);
        if(charSelectorValue == nullptr) {
            return 0;
        }
        
        NSString *selectorStr = [NSString stringWithUTF8String:charSelectorValue];
        env->ReleaseStringUTFChars(javaSelector, charSelectorValue);
        
        SEL selector = NSSelectorFromString(selectorStr);
        if(selectorStr != nil && [touchBarItem respondsToSelector:selector]) {
            return ((int (*)(id, SEL))[touchBarItem methodForSelector:selector])(touchBarItem, selector);
        }
        
        return 0;
    }
    @catch(NSException* e) {
        JNIContext::ThrowJavaException(env, e);
    }
}

+(long) getAWTViewPointer:(JNIEnv*)env cls:(jclass)cls component:(jobject)component {
    @try {
        jclass componentClass = env->GetObjectClass(component);
        jfieldID peerField = env->GetFieldID(componentClass, "peer", "Ljava/awt/peer/ComponentPeer;");
        if(peerField == nullptr) {
            return 0L;
        }
        
        jobject peer = env->GetObjectField(component, peerField);
        if(peer == nullptr) {
            return 0L;
        }
        
        jobject window = JNIContext::CallObjectMethod(env, peer, "getPlatformWindow", "sun/lwawt/PlatformWindow");
        if(window == nullptr) {
            return 0L;
        }
        
        jclass windowClass = env->FindClass("sun/lwawt/macosx/CPlatformWindow");
        if(windowClass == nullptr) {
            return 0L;
        }
        
        jmethodID contentViewMethod = env->GetMethodID(windowClass, "getContentView", "()Lsun/lwawt/macosx/CPlatformView;");
        if(contentViewMethod == nullptr) {
            return 0L;
        }
        
        jobject contentView = env->CallObjectMethod(window, contentViewMethod);
        if(contentView == nullptr) {
            return 0L;
        }
        
        return JNIContext::CallLongMethod(env, contentView, "getAWTView");
    }
    @catch(NSException* e) {
        JNIContext::ThrowJavaException(env, e);
    }
}

@end
