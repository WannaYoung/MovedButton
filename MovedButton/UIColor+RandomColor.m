//
//  UIColor+RandomColor.m
//  MovedButton
//
//  Created by yang on 15/12/7.
//  Copyright © 2015年 yang. All rights reserved.
//

#import "UIColor+RandomColor.h"

@implementation UIColor (RandomColor)

+(UIColor *)randomColor
{
    static BOOL seed = NO;
    if (!seed)
    {
        seed = YES;
        srandom((int)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];
}

@end
