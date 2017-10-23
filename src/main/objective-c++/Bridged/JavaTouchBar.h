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
#import <Foundation/Foundation.h>

#import "JavaTouchBarItem.h"
#import "JavaGroupTouchBarItem.h"

@interface JavaTouchBar : NSObject

@property (nonatomic) jobject javaRepr;

-(NSString*) getCustomizationIdentifier;
-(NSString*) getPrincipalItemIdentifier;

-(NSArray<JavaTouchBarItem*>*) getTouchBarItems;

-(NSTouchBar*) createNSTouchBar;

@end
