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
#import "JavaTouchBarItem.h"

#include <Cocoa/Cocoa.h>

#include <jni.h>
#include <string>

#include "JNIContext.h"
#include "JTouchBarUtils.h"

#include "JavaTouchBar.h"

@interface JavaTouchBarItem() {
    NSString *_identifier;
    NSString *_customizationLabel;
    BOOL _customizationAllowed;
    
    NSView *_view;
}

-(void) updateButton:(NSButton*)button env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView;
-(void) updateTextField:(NSTextField*)textField env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView;
-(void) updateScrubber:(NSScrubber*)scrubber env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView  NS_AVAILABLE_MAC(10_12_2);

-(void) trigger:(id)target;
-(void) sliderValueChanged:(id)target;

@end

@implementation JavaTouchBarItem

-(void) update {
    [self createOrUpdateView];
}

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
        std::string identifier = JNIContext::CallStringMethod(env, _javaRepr, "getIdentifier");
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
        std::string customizationLabel = JNIContext::CallStringMethod(env, _javaRepr, "getCustomizationLabel");
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
        _customizationAllowed = JNIContext::CallBooleanMethod(env, _javaRepr, "isCustomizationAllowed");
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
    
    [self createOrUpdateView];
    
    return _view;
}

-(void) createOrUpdateView {
    @synchronized(_view) {
        JNIEnv *env; JNIContext context(&env);

        jobject jTouchBarView = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
        _view = [self createOrUpdateView:_view jTouchBarView:jTouchBarView];
    }
}

-(NSView*) createOrUpdateView:(NSView*)viewToCreateOrUpdate jTouchBarView:(jobject)jTouchBarView {
    if(jTouchBarView == nullptr) {
        viewToCreateOrUpdate = nil;
        return viewToCreateOrUpdate;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jclass buttonCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarButton");
    if(env->IsInstanceOf(jTouchBarView, buttonCls)) {
        if( viewToCreateOrUpdate == nil || ![viewToCreateOrUpdate isKindOfClass:[NSButton class]]) {
            viewToCreateOrUpdate = [NSButton buttonWithTitle:@"" target:self action:@selector(trigger:)];
        }
        [self updateButton:(NSButton*)viewToCreateOrUpdate env:env jTouchBarView:jTouchBarView];
    }
    
    jclass textFieldCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarTextField");
    if(env->IsInstanceOf(jTouchBarView, textFieldCls)) {
        if( viewToCreateOrUpdate == nil || ![viewToCreateOrUpdate isKindOfClass:[NSTextField class]]) {
            viewToCreateOrUpdate = [NSTextField labelWithString:@""];
        }
        [self updateTextField:(NSTextField*)viewToCreateOrUpdate env:env jTouchBarView:jTouchBarView];
    }
    
    jclass scrubberCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(jTouchBarView, scrubberCls)) {
        if( viewToCreateOrUpdate == nil || ![viewToCreateOrUpdate isKindOfClass:[NSScrubber class]]) {
            viewToCreateOrUpdate = [[NSScrubber alloc] init];
        }
        
        [self updateScrubber:(NSScrubber*)viewToCreateOrUpdate env:env jTouchBarView:jTouchBarView];
    }
    
    jclass sliderCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarSlider");
    if(env->IsInstanceOf(jTouchBarView, sliderCls)) {
        if( viewToCreateOrUpdate == nil || ![viewToCreateOrUpdate isKindOfClass:[NSSlider class]]) {
            viewToCreateOrUpdate = [NSSlider sliderWithTarget:self action:@selector(sliderValueChanged:)];
        }
        
        [self updateSlider:(NSSlider*)viewToCreateOrUpdate env:env jTouchBarView:jTouchBarView];
    }
    
    [self setNativeInstancePointer:jTouchBarView toInstance:viewToCreateOrUpdate];
    
    return viewToCreateOrUpdate;
}

-(void) updateButton:(NSButton*)button env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView {
    // update title
    std::string title = JNIContext::CallStringMethod(env, jTouchBarView, "getTitle");
    std::string alternateTitle = JNIContext::CallStringMethod(env, jTouchBarView, "getAlternateTitle");
    
    color_t color = JNIContext::CallColorMethod(env, jTouchBarView, "getBezelColor");
    
    image_t image = JNIContext::CallImageMethod(env, jTouchBarView, "getImage");
    image_t alternateImage = JNIContext::CallImageMethod(env, jTouchBarView, "getAlternateImage");
    
    int imagePosition = JNIContext::CallIntMethod(env, jTouchBarView, "getImagePosition");
    
    NSImage *nsImage = [JTouchBarUtils getNSImage:image];
    NSImage *nsAlternateImage = [JTouchBarUtils getNSImage:alternateImage];
    
    bool allowsMixedState = JNIContext::CallBooleanMethod(env, jTouchBarView, "getAllowsMixedState");
    
    int buttonType = JNIContext::CallIntMethod(env, jTouchBarView, "getButtonType");
    bool enabled = JNIContext::CallBooleanMethod(env, jTouchBarView, "isEnabled");
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(!title.empty()) {
            [button setTitle:[NSString stringWithUTF8String:title.c_str()]];
        }
        
        if(!alternateTitle.empty()) {
            [button setAlternateTitle:[NSString stringWithUTF8String:alternateTitle.c_str()]];
        }
        
        if(nsImage != nil) {
            [button setImage:nsImage];
            [button setImagePosition:(NSCellImagePosition)imagePosition];
        }
        
        if(nsAlternateImage != nil) {
            [button setAlternateImage:nsAlternateImage];
            [button setImagePosition:(NSCellImagePosition)imagePosition]; // ensure image position has been set
        }
        
        [button setBezelColor:[JTouchBarUtils getNSColor:color]];
        
        [button setButtonType:(NSButtonType)buttonType];
        [button setAllowsMixedState:allowsMixedState];
        [button setEnabled:enabled];
    });
}

-(void) updateTextField:(NSTextField*)textField env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView {
    // update stringValue
    std::string stringValue = JNIContext::CallStringMethod(env, jTouchBarView, "getStringValue");
    dispatch_async(dispatch_get_main_queue(), ^{
        [textField setStringValue:[NSString stringWithUTF8String:stringValue.c_str()]];
    });
}

-(void) updateScrubber:(NSScrubber*)scrubber env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView NS_AVAILABLE_MAC(10_12_2) {
    scrubber.delegate = self;
    scrubber.dataSource = self;
    
    int mode = JNIContext::CallIntMethod(env, jTouchBarView, "getMode"); // NSScrubberModeFree/NSScrubberModeFixed
    scrubber.mode = (NSScrubberMode)mode;
    scrubber.showsArrowButtons = JNIContext::CallBooleanMethod(env, jTouchBarView, "getShowsArrowButtons");
    
    color_t color = JNIContext::CallColorMethod(env, jTouchBarView, "getBackgroundColor");
    dispatch_async(dispatch_get_main_queue(), ^{
        [scrubber setBackgroundColor:[JTouchBarUtils getNSColor:color]];
    });
    
    int overlayStyle = JNIContext::CallIntMethod(env, jTouchBarView, "getSelectionOverlayStyle");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(overlayStyle == 1) {
            [scrubber setSelectionOverlayStyle:[NSScrubberSelectionStyle outlineOverlayStyle]];
        }
        else if(overlayStyle == 2) {
            [scrubber setSelectionOverlayStyle:[NSScrubberSelectionStyle roundedBackgroundStyle]];
        }
    });
    
    int backgroundStyle = JNIContext::CallIntMethod(env, jTouchBarView, "getSelectionOverlayStyle");
    dispatch_async(dispatch_get_main_queue(), ^{
        if(backgroundStyle == 1) {
            [scrubber setSelectionBackgroundStyle:[NSScrubberSelectionStyle outlineOverlayStyle]];
        }
        else if(backgroundStyle == 2) {
            [scrubber setSelectionBackgroundStyle:[NSScrubberSelectionStyle roundedBackgroundStyle]];
        }
    });
}

-(void) updateSlider:(NSSlider*)slider env:(JNIEnv*)env jTouchBarView:(jobject)jTouchBarView NS_AVAILABLE_MAC(10_12_2) {
    double minValue = JNIContext::CallDoubleMethod(env, jTouchBarView, "getMinValue");
    [slider setMinValue:minValue];
    
    double maxValue = JNIContext::CallDoubleMethod(env, jTouchBarView, "getMaxValue");
    [slider setMaxValue:maxValue];
}

#pragma mark - NSButton

-(void) trigger:(id)target {
    if(_javaRepr == nullptr) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarview = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    if(touchBarview == nullptr) {
        return;
    }
    
    jclass buttonCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarButton");
    if(env->IsInstanceOf(touchBarview, buttonCls)) {
        JNIContext::CallVoidMethod(env, touchBarview, "trigger");
    }
    
    env->DeleteLocalRef(touchBarview);
}

-(void) sliderValueChanged:(id)target {
    if(_javaRepr == nullptr) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    if(touchBarView == nullptr) {
        return;
    }
    
    jclass sliderCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarSlider");
    if(env->IsInstanceOf(touchBarView, sliderCls)) {
        jobject actionListener = JNIContext::CallObjectMethod(env, touchBarView, "getActionListener", "com/thizzer/jtouchbar/slider/SliderActionListener");
        if(actionListener == nullptr) {
            return;
        }
        
        JNIContext::CallVoidMethod(env, actionListener, "sliderValueChanged", "Lcom/thizzer/jtouchbar/item/view/TouchBarSlider;D", touchBarView, [target doubleValue]);
    }
    
    env->DeleteLocalRef(touchBarView);
}

#pragma mark - NSScrubberDelegate
- (void)scrubber:(NSScrubber *)scrubber didSelectItemAtIndex:(NSInteger)selectedIndex {
    if(_javaRepr == nullptr) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    if(touchBarView == nullptr) {
        return;
    }
    
    jclass scrubberCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, scrubberCls)) {
        jobject actionListener = JNIContext::CallObjectMethod(env, touchBarView, "getActionListener", "com/thizzer/jtouchbar/scrubber/ScrubberActionListener");
        if(actionListener == nullptr) {
            return;
        }
        
        JNIContext::CallVoidMethod(env, actionListener, "didSelectItemAtIndex", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;J", touchBarView, selectedIndex);
    }
    
    env->DeleteLocalRef(touchBarView);
}

#pragma mark - NSScrubberDataSource {

-(NSInteger) numberOfItemsForScrubber:(NSScrubber *)scrubber {
    if(_javaRepr == nullptr) {
        return 0;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    if(touchBarView == nullptr) {
        return 0;
    }
    
    jclass scrubberCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, scrubberCls)) {
        jobject dataSource = JNIContext::CallObjectMethod(env, touchBarView, "getDataSource", "com/thizzer/jtouchbar/scrubber/ScrubberDataSource");
        if(dataSource == nullptr) {
            return 0; // TODO delete local ref
        }
        
        return JNIContext::CallIntMethod(env, dataSource, "getNumberOfItems", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;", touchBarView);
    }
    
    env->DeleteLocalRef(touchBarView);
    
    return 0;
}

-(NSScrubberItemView *) scrubber:(NSScrubber *)scrubber viewForItemAtIndex:(NSInteger)index {
    if(_javaRepr == nullptr) {
        return nil;
    }
    
    JNIEnv *env; JNIContext context(&env);
    
    jobject touchBarView = JNIContext::CallObjectMethod(env, _javaRepr, "getView", "com/thizzer/jtouchbar/item/view/TouchBarView");
    if(touchBarView == nullptr) {
        return nil;
    }
    
    jclass scrubberCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/item/view/TouchBarScrubber");
    if(env->IsInstanceOf(touchBarView, scrubberCls)) {
        jobject dataSource = JNIContext::CallObjectMethod(env, touchBarView, "getDataSource", "com/thizzer/jtouchbar/scrubber/ScrubberDataSource");
        if(dataSource == nullptr) {
            return nil; // TODO delete local ref
        }
        
        jobject javaScrubberView = JNIContext::CallObjectMethod(env, dataSource, "getViewForIndex", "com/thizzer/jtouchbar/scrubber/view/ScrubberView", "Lcom/thizzer/jtouchbar/item/view/TouchBarScrubber;J", touchBarView, index);
        if(javaScrubberView == nullptr) {
            return nil; // TODO delete local ref
        }
        
        std::string identifier = JNIContext::CallStringMethod(env, javaScrubberView, "getIdentifier");
        
        jclass textItemViewCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/scrubber/view/ScrubberTextItemView");
        if(env->IsInstanceOf(javaScrubberView, textItemViewCls)) {
            NSScrubberTextItemView *textItemView = [[NSScrubberTextItemView alloc] init];
            
            std::string stringValue = JNIContext::CallStringMethod(env, javaScrubberView, "getStringValue");
            [textItemView.textField setStringValue:[NSString stringWithUTF8String:stringValue.c_str()]];
            
            return textItemView; // TODO delete local ref
        }
        
        jclass imageItemViewCls = JNIContext::GetOrFindClass(env, "com/thizzer/jtouchbar/scrubber/view/ScrubberImageItemView");
        if(env->IsInstanceOf(javaScrubberView, imageItemViewCls)) {
            NSScrubberImageItemView *imageItemView = [[NSScrubberImageItemView alloc] init];
            
            image_t image = JNIContext::CallImageMethod(env, javaScrubberView, "getImage");
            NSImage *nsImage = [JTouchBarUtils getNSImage:image];
            if(nsImage != nil) {
                [imageItemView setImage:nsImage];
            }
            
            NSImageAlignment alignment = (NSImageAlignment)JNIContext::CallIntMethod(env, javaScrubberView, "getAlignment");
            [imageItemView setImageAlignment:alignment];
            
            return imageItemView; // TODO delete local ref
        }
    }
    
    env->DeleteLocalRef(touchBarView);
    
    return nil;
}

-(void) setJavaRepr:(jobject)javaRepr {
    JNIEnv *env; JNIContext context(&env);
    if(_javaRepr != NULL) {
        env->DeleteGlobalRef(_javaRepr);
    }
    
    if(javaRepr != NULL) {
        _javaRepr = env->NewGlobalRef(javaRepr);
        [self setNativeInstancePointer:_javaRepr toInstance:self];
    }
    else {
        _javaRepr = NULL;
    }
}

-(void) setNativeInstancePointer:(jobject)nativeLinkObj toInstance:(id)instance {
    if(nativeLinkObj == NULL) {
        return;
    }
    
    JNIEnv *env; JNIContext context(&env);
    JNIContext::CallVoidMethod(env, nativeLinkObj, "setNativeInstancePointer", "J", (long) instance);
}

-(void)dealloc {
    [self setJavaRepr:NULL];
}

@end
