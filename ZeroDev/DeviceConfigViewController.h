//
//  DeviceConfigViewController.h
//  ZeroDev
//
//  Created by admin on 16/1/29.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ELNetworkService/ELNetworkService.h>
#import "EGORefreshTableHeaderView.h"
@interface DeviceConfigViewController : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

@property(nonatomic,strong) ELDeviceObject *deviceObject;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end
