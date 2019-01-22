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
#import <Foundation/Foundation.h>

#include <jni.h>

@interface JTouchBarBridge : NSObject

+(void) setTouchBar:(JNIEnv*)env cls:(jclass)cls viewOrWindowPointerValue:(long)viewOrWindowPointerValue touchBar:(jobject)touchBar;

+(void) updateTouchBarItem:(JNIEnv*)env cls:(jclass)cls itemPointer:(long)itemPointer;

+(void) callObjectSelector:(JNIEnv*)env cls:(jclass)cls objectPointer:(long)objectPointer selector:(jstring)javaSelector onMainThread:(jboolean)onMainThread;

+(int) callIntObjectSelector:(JNIEnv*)env cls:(jclass)cls objectPointer:(long)objectPointer selector:(jstring)javaSelector;

+(long) getAWTViewPointer:(JNIEnv*)env cls:(jclass)cls component:(jobject)component;

@end
