//
//  AppManager.h
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^DataHandler)(BOOL isSuc);


/*
 *
 * 负责下载APP应用，提供APP资源的访问路径
 *
 */
@interface AppManager : NSObject
//资源根路径
+(NSString *)homePath;

//uilibs--ui 路径
+(NSString *)uiRootPath;
//bundle ui
+(NSString *)bundleUIPath;

+(void)downloadApp:(NSString *)url block:(DataHandler)handler;

@end
