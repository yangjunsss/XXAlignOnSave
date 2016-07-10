//
//  XAlignPluginConfig+OnSave.m
//  XAlign
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yangjunsss. All rights reserved.
//

#import "XAlignPluginConfig+OnSave.h"
#import "XXAlignOnSavePlugin.h"
#import "NSObject+Plugin.h"
#define KEY_XXAlignOnSavePlugin_ENABLE @"KEY_XXAlignOnSavePlugin_ENABLE"

@implementation XAlignPluginConfig (OnSave)
+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleClass:[XAlignPluginConfig class] originalSelector:NSSelectorFromString(@"setupMenu") swizzledSelector:NSSelectorFromString(@"xxalignonsave_setupMenu") instanceMethod:NO];
    });
}


+ (void)xxalignonsave_setupMenu
{
    [self xxalignonsave_setupMenu];
    NSMenuItem * editMenuItem   = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    NSMenuItem * alignMenuItem = [[editMenuItem submenu] itemWithTitle:@"XAlign"];
    if (alignMenuItem) {
        alignMenuItem.title = @"XXAlign";
        NSMenuItem * onSaveMenuItem = [[NSMenuItem alloc] init];
        [[alignMenuItem submenu] insertItem:onSaveMenuItem atIndex:0];
        onSaveMenuItem.title = @"Auto Align On Save";
        onSaveMenuItem.target = self;
        onSaveMenuItem.action = NSSelectorFromString(@"doMenuAction:");
        onSaveMenuItem.state = [XXAlignOnSavePlugin sharedInstance].bEnable ? NSOnState : NSOffState;
    }
}

+ (void)doMenuAction:(NSMenuItem *)item
{
    [XXAlignOnSavePlugin sharedInstance].bEnable = ![XXAlignOnSavePlugin sharedInstance].bEnable;
    item.state = [XXAlignOnSavePlugin sharedInstance].bEnable ? NSOnState : NSOffState;
    [[NSUserDefaults standardUserDefaults] setBool:[XXAlignOnSavePlugin sharedInstance].bEnable forKey:KEY_XXAlignOnSavePlugin_ENABLE];
}

@end
