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
#import "JavaTouchBarItem.h"

#include <Cocoa/Cocoa.h>

#include <jni.h>
#include <string>

#include "JNIContext.h"
#include "JNIUtils.h"

#include "JavaTouchBar.h"

@interface JavaTouchBarItem() {
    NSString *_identifier;
    NSString *_customizationLabel;
    BOOL _customizationAllowed;
}

-(void) trigger:(id)target;
@end

@implementation JavaTouchBarItem

-(NSTouchBarItem*) getTouchBarItem {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    NSString *identifier = [self getIdentifier:env reload:TRUE];
    
    NSCustomTouchBarItem *item = [[NSCustomTouchBarItem alloc] initWithIdentifier:identifier];
    item.customizationLabel = [self getCustomizationLabel:env reload:TRUE];
    item.view = [self getView];
        
    return item;
}

-(NSString*) getIdentifier:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        std::string identifier = JNIUtils::CallStringMethod(env, _javaRepr, "getIdentifier");
        if(identifier.empty()) {
            _identifier = nil;
        }
        else {
            _identifier = [NSString stringWithUTF8String:identifier.c_str()];
        }
    }
    
    return _identifier;
}

-(NSString*) getIdentifier {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    return [self getIdentifier:env reload:TRUE];
}

-(NSString*) getCustomizationLabel:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        std::string customizationLabel = JNIUtils::CallStringMethod(env, _javaRepr, "getCustomizationLabel");
        if(customizationLabel.empty()) {
            _customizationLabel = nil;
        }
        else {
            _customizationLabel = [NSString stringWithUTF8String:customizationLabel.c_str()];
        }
    }
    
    return _customizationLabel;
}

-(NSString*) getCustomizationLabel {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    return [self getCustomizationLabel:env reload:TRUE];
}

-(BOOL) isCustomizationAllowed:(JNIEnv*)env reload:(BOOL)reload {
    if(reload) {
        _customizationAllowed = JNIUtils::CallBooleanMethod(env, _javaRepr, "isCustomizationAllowed");
    }
    
    return _customizationAllowed;
}

-(BOOL) isCustomizationAllowed {
    if(_javaRepr == NULL) {
        return FALSE;
    }

    JNIEnv *env; JNIContext context(&env);
    return [self isCustomizationAllowed:env reload:TRUE];
}

-(NSView*) getView {
    if(_javaRepr == NULL) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject jTouchBarView = JNIUtils::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    
    jclass buttonCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarButton");
    if(env->IsInstanceOf(jTouchBarView, buttonCls)) {
        std::string title = JNIUtils::CallStringMethod(env, jTouchBarView, "getTitle");
        NSButton *button = [NSButton buttonWithTitle:[NSString stringWithUTF8String:title.c_str()] target:self action:@selector(trigger:)];
        
        color_t color = JNIUtils::CallColorMethod(env, jTouchBarView, "getBezelColor");
        [button setBezelColor:[NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha]];
        
        image_t image = JNIUtils::CallImageMethod(env, jTouchBarView, "getImage");
        if(!image.name.empty()) {
            NSImage *nsImage = [NSImage imageNamed:[NSString stringWithUTF8String:image.name.c_str()]];
            [button setImage:nsImage];
        }
        else if(!image.path.empty()) {
            NSImage *nsImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:image.path.c_str()]];
            [button setImage:nsImage];
        }
        
        if(button.image != nil) {
            int imagePosition = JNIUtils::CallIntMethod(env, jTouchBarView, "getImagePosition");
            [button setImagePosition:(NSCellImagePosition)imagePosition];
        }
       
        return button;
    }
    
    jclass textFieldCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarTextField");
    if(env->IsInstanceOf(jTouchBarView, textFieldCls)) {
        // get title
        std::string stringValue = JNIUtils::CallStringMethod(env, jTouchBarView, "getStringValue");
        NSTextField *textField = [NSTextField labelWithString:[NSString stringWithUTF8String:stringValue.c_str()]];
        
        return textField;
    }
    
    jclass scrubberCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(jTouchBarView, scrubberCls)) {
        NSScrubber *scrubber = [[NSScrubber alloc] init];
        scrubber.delegate = self;
        scrubber.dataSource = self;
        
        int mode = JNIUtils::CallIntMethod(env, jTouchBarView, "getMode"); // NSScrubberModeFree/NSScrubberModeFixed
        scrubber.mode = (NSScrubberMode)mode;
        scrubber.showsArrowButtons = JNIUtils::CallBooleanMethod(env, jTouchBarView, "getShowsArrowButtons");
        
        color_t color = JNIUtils::CallColorMethod(env, jTouchBarView, "getBackgroundColor");
        [scrubber setBackgroundColor:[NSColor colorWithRed:color.red green:color.green blue:color.blue alpha:color.alpha]];
        
        int overlayStyle = JNIUtils::CallIntMethod(env, jTouchBarView, "getSelectionOverlayStyle");
        if(overlayStyle == 1) {
            [scrubber setSelectionOverlayStyle:[NSScrubberSelectionStyle outlineOverlayStyle]];
        }
        else if(overlayStyle == 2) {
            [scrubber setSelectionOverlayStyle:[NSScrubberSelectionStyle roundedBackgroundStyle]];
        }
        
        int backgroundStyle = JNIUtils::CallIntMethod(env, jTouchBarView, "getSelectionOverlayStyle");
        if(backgroundStyle == 1) {
            [scrubber setSelectionBackgroundStyle:[NSScrubberSelectionStyle outlineOverlayStyle]];
        }
        else if(backgroundStyle == 2) {
            [scrubber setSelectionBackgroundStyle:[NSScrubberSelectionStyle roundedBackgroundStyle]];
        }
        
        return scrubber;
    }
    
    return nil;
}

-(void) trigger:(id)target {
    if(_javaRepr == nullptr) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarview = JNIUtils::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    
    jclass buttonCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarButton");
    if(env->IsInstanceOf(touchBarview, buttonCls)) {
        JNIUtils::CallVoidMethod(env, touchBarview, "trigger");
    }
}

#pragma mark - NSScrubberDelegate
- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    if(_javaRepr == nullptr) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIUtils::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    
    jclass buttonCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, buttonCls)) {
        jobject actionListener = JNIUtils::CallObjectMethod(env, touchBarView, "getActionListener", "com/thizzer/jtouchbar/scrubber/ScrubberActionListener");
        if(actionListener == nullptr) {
            return;
        }
        
        JNIUtils::CallVoidMethod(env, actionListener, "didSelectItemAtIndex", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;J", touchBarView, selectedIndex);
    }
}

#pragma mark - NSScrubberDataSource {

-(NSInteger) numberOfItemsForScrubber:(NSScrubber *)scrubber {
    if(_javaRepr == nullptr) {
        return 0;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIUtils::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    
    jclass buttonCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, buttonCls)) {
        jobject dataSource = JNIUtils::CallObjectMethod(env, touchBarView, "getDataSource", "com/thizzer/jtouchbar/scrubber/ScrubberDataSource");
        if(dataSource == nullptr) {
            return 0;
        }
        
        return JNIUtils::CallIntMethod(env, dataSource, "getNumberOfItems", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;", touchBarView);
    }
    
    return 0;
}

-(NSScrubberItemView *) scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index {
    if(_javaRepr == nullptr) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIUtils::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    
    jclass buttonCls = env->FindClass("com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, buttonCls)) {
        jobject dataSource = JNIUtils::CallObjectMethod(env, touchBarView, "getDataSource", "com/thizzer/jtouchbar/scrubber/ScrubberDataSource");
        if(dataSource == nullptr) {
            return nil;
        }
        
        jobject javaScrubberView = JNIUtils::CallObjectMethod(env, dataSource, "getViewForIndex", "com/thizzer/jtouchbar/scrubber/view/ScrubberView", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;J", touchBarView, index);
        if(javaScrubberView == nullptr) {
            return nil;
        }
        
        std::string identifier = JNIUtils::CallStringMethod(env, javaScrubberView, "getIdentifier");
        
        // TODO use full class..
        jclass textItemViewCls = env->FindClass("com/thizzer/jtouchbar/scrubber/view/ScrubberTextItemView");
        if(env->IsInstanceOf(javaScrubberView, textItemViewCls)) {
            NSScrubberTextItemView *textItemView = [[NSScrubberTextItemView alloc] init];
            
            std::string stringValue = JNIUtils::CallStringMethod(env, javaScrubberView, "getStringValue");
            [textItemView.textField setStringValue:[NSString stringWithUTF8String:stringValue.c_str()]];
            
            return textItemView;
        }
        
        jclass imageItemViewCls = env->FindClass("com/thizzer/jtouchbar/scrubber/view/ScrubberImageItemView");
        if(env->IsInstanceOf(javaScrubberView, imageItemViewCls)) {
            NSScrubberImageItemView *imageItemView = [[NSScrubberImageItemView alloc] init];
            
            image_t image = JNIUtils::CallImageMethod(env, javaScrubberView, "getImage");
            if(!image.name.empty()) {
                NSImage *nsImage = [NSImage imageNamed:[NSString stringWithUTF8String:image.name.c_str()]];
                [imageItemView setImage:nsImage];
            }
            else if(!image.path.empty()) {
                NSImage *nsImage = [[NSImage alloc] initWithContentsOfFile:[NSString stringWithUTF8String:image.path.c_str()]];
                [imageItemView setImage:nsImage];
            }
            
            NSImageAlignment alignment = (NSImageAlignment)JNIUtils::CallIntMethod(env, javaScrubberView, "getAlignment");
            [imageItemView setImageAlignment:alignment];
            
            return imageItemView;
        }
    }
    
    return nil;
}

-(void) setJavaRepr:(jobject)javaRepr {
    JNIEnv *env; JNIContext context(&env);
    if(_javaRepr != NULL) {
        env->DeleteGlobalRef(_javaRepr);
    }
    
    _javaRepr = env->NewGlobalRef(javaRepr);
}

-(void)dealloc {
    [self setJavaRepr:NULL];
}

@end
