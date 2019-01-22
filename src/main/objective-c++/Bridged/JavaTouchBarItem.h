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
#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

#include <jni.h>

NS_CLASS_AVAILABLE_MAC(10_12_2)
@interface JavaTouchBarItem : NSObject <NSScrubberDelegate, NSScrubberDataSource>

@property (nonatomic) jobject javaRepr;

-(void) update;

-(NSTouchBarItem*) getTouchBarItem; 

-(NSString*) getIdentifier:(JNIEnv*)env reload:(BOOL)reload;
-(NSString*) getIdentifier;

-(NSString*) getCustomizationLabel:(JNIEnv*)env reload:(BOOL)reload;
-(NSString*) getCustomizationLabel;

-(BOOL) isCustomizationAllowed:(JNIEnv*)env reload:(BOOL)reload;
-(BOOL) isCustomizationAllowed;

-(NSView*) createOrUpdateView:(NSView*)viewToCreateOrUpdate jTouchBarView:(jobject)jTouchBarView;

@end
