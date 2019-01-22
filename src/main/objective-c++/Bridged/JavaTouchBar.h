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
#import <Foundation/Foundation.h>

#import "JavaTouchBarItem.h"

NS_CLASS_AVAILABLE_MAC(10_12_2)
@interface JavaTouchBar : NSObject

@property (nonatomic) jobject javaRepr;

-(NSString*) getCustomizationIdentifier;
-(NSString*) getPrincipalItemIdentifier;

-(NSArray<JavaTouchBarItem*>*) getTouchBarItems;

-(NSTouchBar*) createNSTouchBar NS_AVAILABLE_MAC(10_12_2);

@end
