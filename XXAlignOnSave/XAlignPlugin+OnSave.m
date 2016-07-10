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
    NSTextView * textView = [SharedXcode textView];
    IDESourceCodeDocument * document = [SharedXcode sourceCodeDocument];
    IDESourceCodeEditor *editor = [SharedXcode currentEditor];
    if ( !document || !editor )
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
        if ([allcontent length] > [XXAlignOnSavePlugin sharedInstance].maxLine) {
            NSLog(@"file line exceed the max limitation:%zd",[XXAlignOnSavePlugin sharedInstance].maxLine);
            return;
        }
        NSString * replace = [allcontent stringByAligning];
        if ( replace )
        {
            
            NSTextView *textView = [editor textView];
            NSRange curRange = textView.selectedRange;
            
            [[document textStorage] beginEditing];
            [[document textStorage] replaceCharactersInRange:NSMakeRange(0, allcontent.length) withString:replace withUndoManager:[document undoManager]];
            [[document textStorage] indentCharacterRange:NSMakeRange(0, allcontent.length) undoManager:[document undoManager]];
            [[document textStorage] endEditing];
            
            [textView setSelectedRange:curRange];
            [textView scrollRangeToVisible:curRange];
        }
    }
    
}
@end
