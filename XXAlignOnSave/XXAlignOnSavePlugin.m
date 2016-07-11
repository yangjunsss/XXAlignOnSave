//
//  XXAlignOnSavePlugin.m
//
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yangjunsss. All rights reserved.
//

#import "XXAlignOnSavePlugin.h"
#import "NSObject+Plugin.h"

#define KEY_XXAlignOnSavePlugin_ENABLE @"KEY_XXAlignOnSavePlugin_ENABLE"

@implementation XXAlignOnSavePlugin


+ (instancetype)sharedInstance
{
    static XXAlignOnSavePlugin* instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance         = [XXAlignOnSavePlugin new];
        instance.bEnable = [[NSUserDefaults standardUserDefaults] objectForKey:KEY_XXAlignOnSavePlugin_ENABLE] == nil ? YES : [[NSUserDefaults standardUserDefaults] boolForKey:KEY_XXAlignOnSavePlugin_ENABLE];
        
        Class IDEEditorDocumentClass = NSClassFromString(@"IDEEditorDocument");
        [self swizzleClass:IDEEditorDocumentClass originalSelector:NSSelectorFromString(@"ide_saveDocument:") swizzledSelector:NSSelectorFromString(@"xxalignonsave_ide_saveDocument:") instanceMethod:YES];
        instance.fileTypes      = [[NSSet alloc] initWithArray:@[@"public.c-header",@"public.c-plus-plus-header",@"public.c-source",@"public.objective-c-source",@"public.c-plus-plus-source",@"public.objective-c-plus-plus-source"]];
        instance.maxLength      = 1000000;
        instance.bSourceChanged = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleIDENotification:) name:nil object:nil];
        
    });
    
    return instance;
}

+ (void)handleIDENotification:(NSNotification *)notify
{
    if([notify.name isEqualToString:@"IDEEditorDocumentDidChangeNotification"]){
        DVTTextDocumentLocation *location = [notify.userInfo[@"IDEEditorDocumentChangeLocationsKey"] firstObject];
        if (location) {
            NSRange lineR                                       = location.lineRange;
            [XXAlignOnSavePlugin sharedInstance].bSourceChanged = lineR.location > 0;
        }
    }
}
@end
