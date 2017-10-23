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
#import <Foundation/Foundation.h>
#include <Cocoa/Cocoa.h>

#include <jni.h>

@interface JavaTouchBarItem : NSObject <NSScrubberDelegate, NSScrubberDataSource>

@property (nonatomic) jobject javaRepr;

-(NSTouchBarItem*) getTouchBarItem;

-(NSString*) getIdentifier:(JNIEnv*)env reload:(BOOL)reload;
-(NSString*) getIdentifier;

-(NSString*) getCustomizationLabel:(JNIEnv*)env reload:(BOOL)reload;
-(NSString*) getCustomizationLabel;

-(BOOL) isCustomizationAllowed:(JNIEnv*)env reload:(BOOL)reload;
-(BOOL) isCustomizationAllowed;

@end
