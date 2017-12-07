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
#include "JTouchBarJNI.h"

#include <Cocoa/Cocoa.h>
#include <JavaVM/JavaVM.h>

#include "JNIContext.h"
#include "JavaTouchBarResponder.h"

static NSMapTable<NSWindow*, JavaTouchBarResponder*> *windowMapping = [NSMapTable weakToStrongObjectsMapTable];

JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_setTouchBar0(JNIEnv *env, jclass cls, jlong viewPointer, jobject touchBar) {
    void* nsViewPointer = (void*)viewPointer;
    if(nsViewPointer == nullptr) {
        return;
    }
    
    NSView *nsView = (__bridge NSView*) (nsViewPointer);
    if(nsView == nil) {
        return;
    }
    
    NSWindow *nsWindow = nsView.window;
    if(nsWindow == nil) {
        return;
    }
    
    if(touchBar == nullptr){
        // TODO remove touchbar for window
        return;
    }

    JavaTouchBarResponder *jTouchBarResponder = [windowMapping objectForKey:nsWindow];
    if(jTouchBarResponder == nil) {
        JavaTouchBar *jTouchBar = [[JavaTouchBar alloc] init];
        jTouchBar.javaRepr = touchBar;

        jTouchBarResponder = [[JavaTouchBarResponder alloc] initWithWindow:nsWindow andJavaTouchBar:jTouchBar];
        [windowMapping setObject:jTouchBarResponder forKey:nsWindow];
    }
    else {
        // TODO delete old global ref
        jTouchBarResponder.jTouchBar.javaRepr = touchBar;
    }
}

JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_updateTouchBarItem(JNIEnv *env, jclass cls, jlong itemPointer) {
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

JNIEXPORT jlong JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_getAWTViewPointer0(JNIEnv *env, jclass cls, jobject component) {
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
