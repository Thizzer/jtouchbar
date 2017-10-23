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

#include "JavaTouchBarItem.h"

@interface JavaGroupTouchBarItem : JavaTouchBarItem <NSTouchBarDelegate>

@property (nonatomic) jobject javaRepr;

-(NSTouchBarItem*) getTouchBarItem;

-(NSString*) getIdentifier;
-(BOOL) isCustomizationAllowed;

@end
