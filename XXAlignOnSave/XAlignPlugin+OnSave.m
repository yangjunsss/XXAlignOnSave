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
#import "NSString+OnSave.h"
#import "XXAlignOnSavePlugin.h"

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
