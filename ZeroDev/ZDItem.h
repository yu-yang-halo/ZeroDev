//
//  ZDItem.h
//  ZeroDev
//
//  Created by admin on 15/11/18.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,ZDItemType){
    ZDItemType_GROUP,
    ZDItemType_CHILD,
};

@interface ZDItem : NSObject

@property(nonatomic,assign) ZDItemType type;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSArray  *childs;

@end
