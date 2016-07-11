//
//  NSString+OnSave.m
//  XXAlignOnSave
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import "NSString+OnSave.h"

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
