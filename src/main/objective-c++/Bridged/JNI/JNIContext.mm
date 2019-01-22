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
#include "JNIContext.h"

#import <Cocoa/Cocoa.h>
#import <JavaVM/JavaVM.h>

#include <map>

const std::vector<std::string> CACHABLE_CLASSNAMES = {
    "com/thizzer/jtouchbar/item/GroupTouchBarItem",
    "com/thizzer/jtouchbar/item/view/TouchBarView",
    "com/thizzer/jtouchbar/item/view/TouchBarTextField",
    "com/thizzer/jtouchbar/item/view/TouchBarButton",
    "com/thizzer/jtouchbar/item/view/TouchBarScrubber",
    "com/thizzer/jtouchbar/item/view/TouchBarSlider",
};

JavaVM *JAVA_VM = nullptr;
std::map<std::string, jclass> JAVA_CLASS_CACHE;

JNIEXPORT jint JNICALL JNI_OnLoad(JavaVM* vm, void* reserved) {
    JNIEnv* env;
    if (vm->GetEnv(reinterpret_cast<void**>(&env), JNI_VERSION_1_6) != JNI_OK) {
        return -1;
    }
    
    JNIContext::CacheClasses( env, CACHABLE_CLASSNAMES );
    
    // maintain reference to vm
    JAVA_VM = vm;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // ensure application loaded
        NSApplicationLoad();
       
        [NSApplication sharedApplication].automaticCustomizeTouchBarMenuItemEnabled = YES;
    });
    
    return  JNI_VERSION_1_6;
}

JNIContext::JNIContext(JNIEnv **env) {
    _state = (JAVA_VM->GetEnv((void**) env, JNI_VERSION_1_6));

    if (JNI_EDETACHED == _state) {
        JAVA_VM->AttachCurrentThread((void**)env, NULL);
    }
}

JNIContext::~JNIContext() {
    if (JNI_EDETACHED == _state) {
        JAVA_VM->DetachCurrentThread();
    }
}

void JNIContext::CacheClasses(JNIEnv* env, std::vector<std::string> classnames) {   
    try {
        for(std::string& classname : classnames) {
            jclass cls = JNIContext::GetOrFindClass(env, classname);
            if(cls == nullptr) {
                continue;
            }
            
            JAVA_CLASS_CACHE[classname] = (jclass) env->NewGlobalRef(cls);
        }
    }
    catch(exception& e) {
        // TODO log error
    }
}

jclass JNIContext::GetOrFindClass(JNIEnv* env, std::string classname) {
    if(JAVA_CLASS_CACHE.find(classname) != JAVA_CLASS_CACHE.end()) {
        return JAVA_CLASS_CACHE[classname];
    }
    
    jclass cls = env->FindClass(classname.c_str());
    if(cls != nullptr) {
        JAVA_CLASS_CACHE[classname] = (jclass) env->NewGlobalRef(cls);
    }
    
    return cls;
}

jobject JNIContext::CallObjectMethod( JNIEnv* env, jobject target, const std::string& method, const char* cls ) {
    jobject value = nullptr;
    if(target == nullptr) {
        return value;
    }
    
    try {
        std::string signature = "()L" + std::string(cls) + ";";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallObjectMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

jobject JNIContext::CallObjectMethod(JNIEnv* env, jobject target, const std::string& method, const char* cls, const char* argsSig, ...) {
    jobject value = nullptr;
    if(target == nullptr) {
        return value;
    }
    
    try {
        std::string signature = "("+ std::string(argsSig) +")L" + std::string(cls) + ";";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        va_list args;
        va_start(args, argsSig);
        value = env->CallObjectMethodV(target, methodId, args);
        va_end(args);
        
        HandleExceptions(env);
    }
    catch( exception& e) {
        // TODO log error
    }
    
    return value;
}

void JNIContext::CallVoidMethod(JNIEnv* env, jobject target, const std::string& method) {
    if(target == nullptr) {
        return;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()V");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            // TODO log error
        }
        
        env->CallVoidMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
}

void JNIContext::CallVoidMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...) {
    if(target == nullptr) {
        return;
    }
    
    try {
        std::string signature = "("+ std::string(argsSig) +")V";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            // TODO log error
        }
        
        va_list args;
        va_start(args, argsSig);
        env->CallVoidMethodV(target, methodId, args);
        va_end(args);
        
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
}

std::string JNIContext::CallStringMethod(JNIEnv* env, jobject target, const std::string& method) {
    std::string value = "";
    if(target == nullptr) {
        return value;
    }
    
    try {
        jstring javaStringValue = (jstring) JNIContext::CallObjectMethod(env, target, method, "java/lang/String");
        if(javaStringValue == nullptr ) {
            return value;
        }
        
        const char *charValue = env->GetStringUTFChars(javaStringValue, 0);
        if(charValue != nullptr) {
            value = std::string(charValue);
        }
        
        env->ReleaseStringUTFChars(javaStringValue, charValue);
        env->DeleteLocalRef(javaStringValue);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

std::vector<unsigned char> JNIContext::CallByteArrayMethod(JNIEnv* env, jobject target, const std::string& method) {
    std::vector<unsigned char> value;
    if(target == nullptr) {
        return value;
    }
    
    try {
        std::string signature = "()[B";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        jbyteArray bytes = (jbyteArray) env->CallObjectMethod(target, methodId);
        HandleExceptions(env);
        
        if(bytes == nullptr) {
            return value;
        }
        
        int32_t len = env->GetArrayLength((jbyteArray) bytes);
        jbyte *jBytes = env->GetByteArrayElements((jbyteArray) bytes, 0);
        
        value.assign(jBytes, jBytes + len);
        
        env->ReleaseByteArrayElements(bytes, jBytes, JNI_ABORT);
        env->DeleteLocalRef(bytes);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

bool JNIContext::CallBooleanMethod(JNIEnv* env, jobject target, const std::string& method) {
    bool value = false;
    if(target == nullptr) {
        return value;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()Z");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallBooleanMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

jobject JNIContext::CallBooleanObjectMethod(JNIEnv* env, jobject target, const std::string& method) {
    if(target == nullptr) {
        return nullptr;
    }
    
    try {
        return JNIContext::CallObjectMethod(env, target, method, "java/lang/Boolean");
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return nullptr;
}

int32_t JNIContext::CallIntMethod(JNIEnv* env, jobject target, const std::string& method) {
    int32_t value = 0;
    if(target == nullptr) {
        return value;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()I");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallIntMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

int32_t JNIContext::CallIntMethod(JNIEnv* env, jobject target, const std::string& method, const char* argsSig, ...) {
    int32_t value = 0;
    if(target == nullptr) {
        return value;
    }
    
    try {
        std::string signature = "("+ std::string(argsSig) +")I";
        
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), signature.c_str());
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        va_list args;
        va_start(args, argsSig);
        value = env->CallIntMethodV(target, methodId, args);
        va_end(args);
        
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

float JNIContext::CallFloatMethod(JNIEnv* env, jobject target, const std::string& method) {
    float value = 0;
    if(target == nullptr) {
        return value;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()F");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallFloatMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

double JNIContext::CallDoubleMethod(JNIEnv* env, jobject target, const std::string& method) {
    double value = 0.0;
    if(target == nullptr) {
        return value;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()D");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallDoubleMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

long JNIContext::CallLongMethod(JNIEnv* env, jobject target, const std::string& method) {
    long value = 0L;
    if(target == nullptr) {
        return value;
    }
    
    try {
        jclass targetCls = env->GetObjectClass(target);
        jmethodID methodId = env->GetMethodID(targetCls, method.c_str(), "()J");
        
        HandleExceptions(env);
        if(methodId == nullptr) {
            return value;
        }
        
        value = env->CallLongMethod(target, methodId);
        HandleExceptions(env);
    }
    catch(exception& e) {
        // TODO log error
    }
    
    return value;
}

color_t JNIContext::CallColorMethod(JNIEnv* env, jobject target, const std::string& method) {
    color_t color;
    if(target == nullptr) {
        return color;
    }
    
    jobject javaColor = JNIContext::CallObjectMethod(env, target, method, "com/thizzer/jtouchbar/common/Color");
    if(javaColor == nullptr) {
        return color;
    }
    
    color.nsColorKey = JNIContext::CallStringMethod(env, javaColor, "getNsColorKey");
    color.red = JNIContext::CallFloatMethod(env, javaColor, "getRed");
    color.green = JNIContext::CallFloatMethod(env, javaColor, "getGreen");
    color.blue = JNIContext::CallFloatMethod(env, javaColor, "getBlue");
    color.alpha = JNIContext::CallFloatMethod(env, javaColor, "getAlpha");
    
    env->DeleteLocalRef(javaColor);
    
    return color;
}

image_t JNIContext::CallImageMethod(JNIEnv* env, jobject target, const std::string& method) {
    image_t image;
    if(target == nullptr) {
        return image;
    }
    
    jobject javaImage = JNIContext::CallObjectMethod(env, target, method, "com/thizzer/jtouchbar/common/Image");
    if(javaImage == nullptr) {
        return image;
    }
    
    image.name = JNIContext::CallStringMethod(env, javaImage, "getName");
    image.path = JNIContext::CallStringMethod(env, javaImage, "getPath");
    image.data = JNIContext::CallByteArrayMethod(env, javaImage, "getData");
    
    env->DeleteLocalRef(javaImage);
    
    return image;
}

void JNIContext::HandleExceptions(JNIEnv* env) {
    if(env == nullptr) {
        return;
    }
    
    if(env->ExceptionCheck()) {
        // TODO actually handle the exception
        env->ExceptionClear();
    }
}

void JNIContext::ThrowJavaException(JNIEnv* env, NSException* e) {
    if(env == nullptr) {
        return;
    }
    
    std::string classname = "java/lang/RuntimeException";
    if(e.name == NSInvalidArgumentException) {
        classname = "java/lang/IllegalArgumentException";
    }
    
    jclass exceptionClass = GetOrFindClass( env, classname.c_str() );
    if ( exceptionClass == NULL )
    {
        return;
    }

    env->ThrowNew( exceptionClass, [e.description UTF8String] );

}
