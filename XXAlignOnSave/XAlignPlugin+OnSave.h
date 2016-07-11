//
//  XAlignPlugin+OnSave.h
//  XAlign
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yangjunsss. All rights reserved.
//

#import "XAlignPlugin.h"
#import "XAlignPluginConfig.h"

@interface XAlignPlugin (OnSave)
- (void)autoAlignAll;
@end

@interface XAlignPluginConfig (OnSave)

@end

@interface XAlignLine : NSObject
@property (nonatomic, retain) NSMutableArray * partials;
@property (nonatomic        ) NSArray        *patterns;
+ (id)line;
- (NSString *)stringWithPaddings:(NSArray *)paddings patterns:(NSArray *)patterns;
- (void)processLine:(XAlignLine **)line level:(int)level patterns:(NSArray *)patterns paddings:(NSMutableArray *)paddings;
@end

@interface NSString (OnSave)
- (void)processLine:(XAlignLine **)line level:(int)level patterns:(NSArray *)patterns paddings:(NSMutableArray *)paddings;
- (NSString *)stringByAligning;
@end