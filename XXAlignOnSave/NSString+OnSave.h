//
//  NSString+OnSave.h
//  XXAlignOnSave
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+XAlign.h"

@interface XAlignLine : NSObject
@property (nonatomic, retain) NSMutableArray * partials;
@property (nonatomic) NSArray *patterns;
+ (id)line;
- (NSString *)stringWithPaddings:(NSArray *)paddings patterns:(NSArray *)patterns;
- (void)processLine:(XAlignLine **)line level:(int)level patterns:(NSArray *)patterns paddings:(NSMutableArray *)paddings;
@end

@interface NSString (OnSave)
- (void)processLine:(XAlignLine **)line level:(int)level patterns:(NSArray *)patterns paddings:(NSMutableArray *)paddings;
- (NSString *)stringByAligning;
@end
