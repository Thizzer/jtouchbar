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
#import "JTouchBarUtils.h"

#import <Cocoa/Cocoa.h>

@implementation JTouchBarUtils

+(NSImage*) getNSImage:(image_t)image {
    NSImage *nsImage = nil;
    if(!image.name.empty()) {
        nsImage = [NSImage imageNamed:[NSString stringWithUTF8String:image.name.c_str()]];
    }
    else if(!image.path.empty()) {
        NSString *imageFilePath = [NSString stringWithUTF8String:image.path.c_str()];
        if( [imageFilePath hasPrefix:@"file:"]) {
            NSRange filePrefixRange = [imageFilePath rangeOfString:@"file:"];
            imageFilePath = [imageFilePath stringByReplacingOccurrencesOfString:@"file:" withString:@"" options:0 range:filePrefixRange];
        }
        
        nsImage = [[NSImage alloc] initWithContentsOfFile:imageFilePath];
    }
    else if(!image.data.empty()) {
        NSData *nsData = [[NSData alloc] initWithBytes:image.data.data() length:image.data.size()];
        nsImage = [[NSImage alloc] initWithData:nsData];
    }
    
    return nsImage;
}

+(NSColor*) getNSColor:(color_t)color {
    if(color.nsColorKey.empty()) {
        return [NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha];
    }
    
    NSString *nsColorKey = [NSString stringWithUTF8String:color.nsColorKey.c_str()];
    return [NSColor valueForKey:nsColorKey];
}

+(NSTouchBarItem*) touchBar:(NSTouchBar *)touchBar makeItemForIdentifier:(NSTouchBarItemIdentifier)identifier usingJavaTouchBar:(JavaTouchBar*)jTouchBar {
    if(jTouchBar == nil) {
        return nil;
    }
    
    for(JavaTouchBarItem *item in [jTouchBar getTouchBarItems]) {
        NSString *itemIdentifier = [item getIdentifier];
        if( [itemIdentifier isEqualToString:identifier]) {
            return [item getTouchBarItem];
        }
    }
    
    return nil;
}

@end
