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
#ifndef JNICONTEXT_H
#define JNICONTEXT_H

#include <jni.h>

using namespace std;

class JNIContext {
public:
    JNIContext(JNIEnv **env);
    ~JNIContext();
private:
    int _state;

    JNIContext(const JNIContext &);
};

#endif // JNICONTEXT_H
