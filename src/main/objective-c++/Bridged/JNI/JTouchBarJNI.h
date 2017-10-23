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
#ifndef JTOUCHBARJNI_H
#define JTOUCHBARJNI_H

#include <jni.h>

#ifdef __cplusplus
extern "C" {
#endif
    
JNIEXPORT void JNICALL Java_com_thizzer_jtouchbar_JTouchBarJNI_setTouchBar0(JNIEnv *, jclass, jlong, jobject);
    
#ifdef __cplusplus
}
#endif

#endif // JTOUCHBARJNI_H
