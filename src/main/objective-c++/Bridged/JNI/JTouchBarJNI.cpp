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
#include "JTouchBarJNI.h"

#include "JTouchBarBridge.h"

JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_setTouchBar0(JNIEnv *env, jclass cls, jlong viewOrWindowPointerValue, jobject touchBar) {
    [JTouchBarBridge setTouchBar:env cls:cls viewOrWindowPointerValue:viewOrWindowPointerValue touchBar:touchBar];
}

JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_updateTouchBarItem(JNIEnv *env, jclass cls, jlong itemPointer) {
    [JTouchBarBridge updateTouchBarItem:env cls:cls itemPointer:itemPointer];
}

JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_callObjectSelector(JNIEnv *env, jclass cls, jlong objectPointer, jstring javaSelector, jboolean onMainThread) {
    [JTouchBarBridge callObjectSelector:env cls:cls objectPointer:objectPointer selector:javaSelector onMainThread:onMainThread];
}

JNIEXPORT int JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_callIntObjectSelector(JNIEnv *env, jclass cls, jlong objectPointer, jstring javaSelector) {
    return [JTouchBarBridge callIntObjectSelector:env cls:cls objectPointer:objectPointer selector:javaSelector];
}

JNIEXPORT jlong JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_getAWTViewPointer0(JNIEnv *env, jclass cls, jobject component) {
    return [JTouchBarBridge getAWTViewPointer:env cls:cls component:component];
}
