//
//  XAlignPlugin+OnSave.m
//  XAlign
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yangjunsss. All rights reserved.
//

#import "XAlignPlugin+OnSave.h"
#import "XAlignPattern.h"
#import "SharedXcode.h"
#import "NSString+XAlign.h"
#import <Cocoa/Cocoa.h>
#import "XXAlignOnSavePlugin.h"
#import "NSObject+Plugin.h"


#pragma XAlignPlugin category
@implementation XAlignPlugin (OnSave)

- (void)autoAlignAll
{
    NSTextView * textView            = [SharedXcode textView];
    IDESourceCodeDocument * document = [SharedXcode sourceCodeDocument];
    if ( !document )
        return;
    DVTFileDataType *type = [document fileDataType];
    if (![[XXAlignOnSavePlugin sharedInstance].fileTypes containsObject:type.identifier]) {
        NSLog(@"file type not support");
        return;
    }
    
    if (![XXAlignOnSavePlugin sharedInstance].bSourceChanged){
        return;
    }
    
    if (textView) {
        NSString *allcontent = textView.string;
        if ([allcontent length] > [XXAlignOnSavePlugin sharedInstance].maxLength) {
            NSLog(@"file line exceed the max length limitation:%zd",[XXAlignOnSavePlugin sharedInstance].maxLength);
            return;
        }
        NSString * replace = [allcontent stringByAligning];
        if ( replace )
        {
            NSRange curRange               = textView.selectedRange;
            NSRange lineRange              = [[document textStorage] lineRangeForCharacterRange:curRange];
            NSRange charaterRange          = [[document textStorage] characterRangeForLineRange:lineRange];
            NSUInteger charaterIndexInLine = curRange.location - charaterRange.location;
            NSUInteger charaterLength      = curRange.length;
            NSRect visibleRect             = [textView visibleRect];
            
            [[document textStorage] beginEditing];
            [[document textStorage] replaceCharactersInRange:NSMakeRange(0, allcontent.length) withString:replace withUndoManager:[document undoManager]];
            [[document textStorage] indentCharacterRange:NSMakeRange(0, allcontent.length) undoManager:[document undoManager]];
            [[document textStorage] endEditing];
            
            charaterRange              = [[document textStorage] characterRangeForLineRange:lineRange];
            NSRange real_charaterRange = NSMakeRange(charaterRange.location + charaterIndexInLine, charaterLength);
            [textView setSelectedRange:real_charaterRange];
            [textView scrollRectToVisible:visibleRect];
        }
    }
    
}


@end


#pragma XAlignPluginConfig category
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
    NSMenuItem * editMenuItem  = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    NSMenuItem * alignMenuItem = [[editMenuItem submenu] itemWithTitle:@"XAlign"];
    if (alignMenuItem) {
        alignMenuItem.title         = @"XXAlign";
        NSMenuItem * onSaveMenuItem = [[NSMenuItem alloc] init];
        [[alignMenuItem submenu] insertItem:onSaveMenuItem atIndex:0];
        onSaveMenuItem.title  = @"Auto Align On Save";
        onSaveMenuItem.target = self;
        onSaveMenuItem.action = NSSelectorFromString(@"doMenuAction:");
        onSaveMenuItem.state  = [XXAlignOnSavePlugin sharedInstance].bEnable ? NSOnState : NSOffState;
    }
}

+ (void)doMenuAction:(NSMenuItem *)item
{
    [XXAlignOnSavePlugin sharedInstance].bEnable = ![XXAlignOnSavePlugin sharedInstance].bEnable;
    item.state                                   = [XXAlignOnSavePlugin sharedInstance].bEnable ? NSOnState : NSOffState;
    [[NSUserDefaults standardUserDefaults] setBool:[XXAlignOnSavePlugin sharedInstance].bEnable forKey:KEY_XXAlignOnSavePlugin_ENABLE];
}

@end

#pragma NSString category
@implementation NSString (OnSave)

- (NSString *)stringByAligning
{
    NSArray * lines = [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    if ( lines.count <= 1 )
        return self;
    
    NSMutableArray * paddings     = [NSMutableArray array];
    NSMutableArray * processLines = [NSMutableArray array];
    NSMutableString * newLines    = [NSMutableString string];
    NSArray *patterns             = nil;
    
    for ( NSString * line in lines )
    {
        NSString * trimLine = line.xtrimTail;
        
        NSArray *tmpPatterns = [XAlignPatternManager patternGroupMatchWithString:trimLine];
        if ((tmpPatterns == nil && patterns != nil) || (tmpPatterns != nil && tmpPatterns != patterns)) {
            
            for ( int i = 0; i < processLines.count; i++ )
            {
                id line = processLines[i];
                
                if ( [line isKindOfClass:[NSString class]] )
                {
                    [newLines appendString:line];
                }
                else if ( [line isKindOfClass:[XAlignLine class]] )
                {
                    [newLines appendString:[line stringWithPaddings:paddings patterns:patterns]];
                }
                
                if ( i != processLines.count - 1 )
                {
                    [newLines appendString:@"\n"];
                }
                
            }
            
            [newLines appendString:@"\n"];
            
            [paddings removeAllObjects];
            [processLines removeAllObjects];
            
            for ( int j = 0; j < (tmpPatterns.count * 2 + 1); j++ )
            {
                [paddings addObject:@(-1)];
            }
            
            patterns = tmpPatterns;
        }
        
        XAlignLine * xline = nil;
        if (patterns) {
            [trimLine processLine:&xline level:(int)(patterns.count - 1) patterns:patterns paddings:paddings];
        }
        
        if ( !xline )
        {
            [processLines addObject:trimLine];
        }
        else
        {
            [processLines addObject:xline];
        }
        
        
    }
    
    for ( int i = 0; i < processLines.count; i++ )
    {
        id line = processLines[i];
        
        if ( [line isKindOfClass:[NSString class]] )
        {
            [newLines appendString:line];
        }
        else if ( [line isKindOfClass:[XAlignLine class]] )
        {
            [newLines appendString:[line stringWithPaddings:paddings patterns:patterns]];
        }
        
        if ( i != processLines.count - 1 )
        {
            [newLines appendString:@"\n"];
        }
        
    }
    
    return newLines;
}
@end
