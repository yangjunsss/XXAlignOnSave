//
//  NSObject+Plugin.h
//  
//
//  Created by yj on 7/8/16.
//  Copyright © 2016 yj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Plugin)
+ (void)swizzleClass:(nullable Class)class originalSelector:(nullable SEL)originalSelector swizzledSelector:(nullable SEL)swizzledSelector instanceMethod:(BOOL)instanceMethod;
@end
