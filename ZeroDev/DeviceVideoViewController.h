//
//  DeviceVideoViewController.h
//  ZeroDev
//
//  Created by admin on 16/1/30.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//
typedef NS_ENUM(NSUInteger,IP_CAMERA_FILED){
    IP_CAMERA_FILED_UID=387,
    IP_CAMERA_FILED_USERNAME=388,
    IP_CAMERA_FILED_PASSWORD=389,
    IP_CAMERA_FILED_CLASSID=232,
};

#import <UIKit/UIKit.h>
#import <ELNetworkService/ELNetworkService.h>
@interface DeviceVideoViewController : UIViewController
@property(nonatomic,strong) ELDeviceObject *deviceObject;
@end
