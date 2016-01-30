//
//  RegexUtils.m
//  ZeroDev
//
//  Created by admin on 16/1/30.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "RegexUtils.h"

@implementation RegexUtils
+(BOOL)isVaildPass:(NSString *)pass{
    int len=[[pass stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    if(len<6){
        return NO;
    }
    return YES;
}
@end
