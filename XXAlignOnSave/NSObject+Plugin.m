//
//  NSObject+Plugin.m
//
//
//  Created by yj on 7/8/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import "NSObject+Plugin.h"
#import <objc/runtime.h>
#import "XAlignPlugin.h"
#import "XAlignPlugin+OnSave.h"
#import "XXAlignOnSavePlugin.h"
#import "xprivates.h"

@implementation NSObject (Plugin)

-(void) xxalignonsave_ide_saveDocument:(id) arg{
    [self xxalignonsave_ide_saveDocument:arg];
    if([self isKindOfClass:NSClassFromString(@"IDEEditorDocument")]){
        if ([XXAlignOnSavePlugin sharedInstance].bEnable) {
            [[XAlignPlugin sharedInstance] autoAlignAll];
        }
    }
}

+ (void)swizzleClass:(nullable Class)class originalSelector:(nullable SEL)originalSelector swizzledSelector:(nullable SEL)swizzledSelector instanceMethod:(BOOL)instanceMethod{
    if (class) {
        Method originalMethod;
        Method swizzledMethod;
        if (instanceMethod) {
            originalMethod = class_getInstanceMethod(class, originalSelector);
            swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
        } else {
            originalMethod = class_getClassMethod(class, originalSelector);
            swizzledMethod = class_getClassMethod(class, swizzledSelector);
            class          = object_getClass((id)class);
        }
        
        BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}

@end
