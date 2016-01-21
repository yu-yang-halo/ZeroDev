//
//  AnimationUtils.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "AnimationUtils.h"

@implementation AnimationUtils
+(void)addAnimationFromRight:(CALayer *)layer{
     CATransition *animation=[CATransition animation];
    [animation setDuration:5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [layer addAnimation:animation forKey:@"a0"];
}

+(void)addAnimationFromLeft:(CALayer *)layer{
    CATransition *animation=[CATransition animation];
    [animation setDuration:5];
    [animation setType:kCATransitionPush];
    [animation setSubtype:kCATransitionFromLeft];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [layer addAnimation:animation forKey:@"a0"];
}
@end
