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
#include <Cocoa/Cocoa.h>

#import "JNIContext.h"
#import "JavaTouchBar.h"

NS_CLASS_AVAILABLE_MAC(10_12_2)
@interface JTouchBarUtils : NSObject

+(NSImage*) getNSImage:(image_t)image;
+(NSColor*) getNSColor:(color_t)color;

+(NSTouchBarItem*) touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier usingJavaTouchBar:(JavaTouchBar*)jTouchBar;

@end
