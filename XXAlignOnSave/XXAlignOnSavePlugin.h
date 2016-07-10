//
//  XXAlignOnSavePlugin.h
//  
//
//  Created by yj on 7/9/16.
//  Copyright © 2016 yangjunsss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXAlignOnSavePlugin : NSObject
@property (nonatomic) BOOL bEnable;
@property (nonatomic) NSSet *fileTypes;
@property (nonatomic) NSUInteger maxLine;
@property (nonatomic) BOOL bSourceChanged;
+ (instancetype)sharedInstance;
@end
