/**
 * JTouchBar
 *
 * Copyright (c) 2018 thizzer.com
 *
 * This software may be modified and distributed under the terms
 * of the MIT license.  See the LICENSE file for details.
 *
 * @author  	M. ten Veldhuis
 */
#ifndef JTOUCHBARJNI_H
#define JTOUCHBARJNI_H

#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif
    
JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_setTouchBar0(JNIEnv *, jclass, jlong, jobject);
    
JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_updateTouchBarItem(JNIEnv *, jclass, jlong);
    
JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_callObjectSelector(JNIEnv *, jclass, jlong, jstring);
    
JNIEXPORT jlong JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_getAWTViewPointer0(JNIEnv *env, jclass cls, jobject component);
    
JNIEXPORT jlong JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_getJavaFXViewPointer0(JNIEnv *env, jclass cls, jobject window);
    
#ifdef __cplusplus
}
#endif

#endif // JTOUCHBARJNI_H
