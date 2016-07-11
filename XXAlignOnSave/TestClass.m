//
//  TestClass.m
//  XXAlignOnSave
//
//  Created by yj on 7/11/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import "TestClass.h"
#define kPatterns        @"patterns"
#define kPatternID       @"id"
#define kPatternType     @"type"
#define kPatternPosition @"position"

#define kPatternHeadMode              @"headMode"
#define kPatternMatchMode             @"matchMode"
#define kPatternTailMode              @"tailMode"
#define kPatternControlFormat         @"format"
#define kPatternControlNotFoundFormat @"notFoundFormat"
#define kPatternControlNeedTrim       @"needTrim"

@interface TestClass ()
@property (nonatomic) NSString *PatternHeadMode;
@property (nonatomic) NSString *PatternTailMode;

@property (nonatomic,weak  ) NSString *PatternMatchMode;
@property (nonatomic,strong) NSString *PatternControlFormat;
@property (nonatomic,assign) NSString *PatternControlNotFoundFormat;
@end
@implementation TestClass
- (void)testFunc
{
    NSString *PatternHeadMode = kPatternHeadMode;
    NSString *PatternTailMode = kPatternTailMode;
    NSString *Patterns        = kPatterns;
    NSMenuItem *menuItem      = [[NSApp mainMenu] itemWithTitle:@"Edit"];
    if (menuItem) {
        [[menuItem submenu] addItem:[NSMenuItem separatorItem]];
        NSMenuItem *actionMenuItem = [[NSMenuItem alloc] initWithTitle:@"Do Action" action:@selector(doMenuAction) keyEquivalent:@""];
    }
    
    NSString *PatternMatchMode             = kPatternMatchMode;
    NSString *PatternControlFormat         = kPatternControlFormat;
    NSString *PatternControlNotFoundFormat = kPatternControlNotFoundFormat;
    
    
}
@end
