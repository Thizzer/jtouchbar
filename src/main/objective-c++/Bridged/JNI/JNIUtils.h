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
#ifndef JNIUTILS_H
#define JNIUTILS_H

#include <jni.h>

#include <string>

using namespace std;

struct color_t {
    float red, green, blue, alpha = 0.0f;
};

struct image_t {
    std::string name, path = "";
};

class JNIUtils {
public:
    static jobject CallObjectMethod(JNIEnv* env, jobject target, const std::string& method, const char* cls);
    static jobject CallObjectMethod(JNIEnv* env, jobject target, const std::string& method, const char* cls, const char* argsSig, ...);
    
    static void CallVoidMethod(JNIEnv* env, jobject target, const std::string& method);
    static void CallVoidMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...);
    
    static std::string CallStringMethod(JNIEnv* env, jobject target, const std::string& method);
    static bool CallBooleanMethod(JNIEnv* env, jobject target, const std::string& method);
    
    static int32_t CallIntMethod(JNIEnv* env, jobject target, const std::string& method);
    static int32_t CallIntMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...);
    
    static float CallFloatMethod(JNIEnv* env, jobject target, const std::string& method);
    
    static color_t CallColorMethod(JNIEnv* env, jobject target, const std::string& method);
    static image_t CallImageMethod(JNIEnv* env, jobject target, const std::string& method);
};

#endif // JNIUTILS_H
