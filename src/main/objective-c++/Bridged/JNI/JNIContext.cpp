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
#include "JNIContext.h"

#include <Cocoa/Cocoa.h>
#include <JavaVM/JavaVM.h>

JavaVM *javaVM = nullptr;

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
        return -1;
    }
    
    // maintain reference to vm
    javaVM = vm;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // ensure application loaded
        NSApplicationLoad();
       
        [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    });
    
    return  JNI_VERSION_1_6;
}

JNIContext::JNIContext(JNIEnv **env) {
    _state = (javaVM->GetEnv((void**) env, JNI_VERSION_1_6));

    if (JNI_EDETACHED == _state) {
        javaVM->AttachCurrentThread((void**)env, NULL);
    }
}

JNIContext::~JNIContext() {
    if (JNI_EDETACHED == _state) {
        javaVM->DetachCurrentThread();
    }
}
