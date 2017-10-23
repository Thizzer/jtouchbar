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
#include "JNIUtils.h"

jobject JNIUtils::CallObjectMethod(JNIEnv* env, jobject target, const std::string& method, const char* cls) {
    jobject value = nullptr;
    
    try {
        std::string signature = "()L" + std::string(cls) + ";";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallObjectMethod(target, methodId);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

jobject JNIUtils::CallObjectMethod(JNIEnv* env, jobject target, const std::string& method, const char* cls, const char* argsSig, ...) {
    jobject value = nullptr;
    
    try {
        std::string signature = "("+ std::string(argsSig) +")L" + std::string(cls) + ";";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        if(methodId == nullptr) {
            return value;
        }
        
        va_list args;
        va_start(args, argsSig);
        value = env->CallObjectMethodV(target, methodId, args);
        va_end(args);
    }
    catch( exception& e) {
        // TODO log error
    }
    
    return value;
}

void JNIUtils::CallVoidMethod(JNIEnv* env, jobject target, const std::string& method) {
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()V");
        if(methodId == nullptr) {
            // TODO log error
        }
        
        env->CallVoidMethod(target, methodId);
    }
    catch(exception& e) {
        // TODO log error
    }
}

void JNIUtils::CallVoidMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...) {
    try {
        std::string signature = "("+ std::string(argsSig) +")V";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        if(methodId == nullptr) {
            // TODO log error
        }
        
        va_list args;
        va_start(args, argsSig);
        env->CallVoidMethodV(target, methodId, args);
        va_end(args);
    }
    catch(exception& e) {
        // TODO log error
    }
}

std::string JNIUtils::CallStringMethod(JNIEnv* env, jobject target, const std::string& method) {
    std::string value = "";
    
    try {
        jstring javaStringValue = (jstring) JNIUtils::CallObjectMethod(env, target, method, "java/lang/String");
        if(javaStringValue == nullptr ) {
            return value;
        }
        
        const char *charValue = env->GetStringUTFChars(javaStringValue, 0);
        if(charValue != nullptr) {
            value = std::string(charValue);
        }
    
        env->ReleaseStringUTFChars(javaStringValue, charValue);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

bool JNIUtils::CallBooleanMethod(JNIEnv* env, jobject target, const std::string& method) {
    bool value = false;
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()Z");
        
        value = env->CallBooleanMethod(target, methodId);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

int32_t JNIUtils::CallIntMethod(JNIEnv* env, jobject target, const std::string& method) {
    int32_t value = 0;
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()I");
        
        value = env->CallIntMethod(target, methodId);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

int32_t JNIUtils::CallIntMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...) {
    int32_t value = 0;
    
    try {
        std::string signature = "("+ std::string(argsSig) +")I";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        va_list args;
        va_start(args, argsSig);
        value = env->CallIntMethodV(target, methodId, args);
        va_end(args);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

float JNIUtils::CallFloatMethod(JNIEnv* env, jobject target, const std::string& method) {
    float value = 0;
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()F");
        
        value = env->CallFloatMethod(target, methodId);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

color_t JNIUtils::CallColorMethod(JNIEnv* env, jobject target, const std::string& method) {
    color_t color;
    
    jobject javaColor = JNIUtils::CallObjectMethod(env, target, method, "com/thizzer/jtouchbar/common/Color");
    if(javaColor == nullptr) {
        return color;
    }
    
    color.red = JNIUtils::CallFloatMethod(env, javaColor, "getRed");
    color.green = JNIUtils::CallFloatMethod(env, javaColor, "getGreen");
    color.blue = JNIUtils::CallFloatMethod(env, javaColor, "getBlue");
    color.alpha = JNIUtils::CallFloatMethod(env, javaColor, "getAlpha");
    
    return color;
}

image_t JNIUtils::CallImageMethod(JNIEnv* env, jobject target, const std::string& method) {
    image_t image;
    
    jobject javaImage = JNIUtils::CallObjectMethod(env, target, method, "com/thizzer/jtouchbar/common/Image");
    if(javaImage == nullptr) {
        return image;
    }
    
    image.name = JNIUtils::CallStringMethod(env, javaImage, "getName");
    image.path = JNIUtils::CallStringMethod(env, javaImage, "getPath");
    
    return image;
}
