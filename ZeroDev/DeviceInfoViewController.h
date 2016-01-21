//
//  DeviceInfoViewController.h
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ELNetworkService/ELNetworkService.h>
#import "EGORefreshTableHeaderView.h"
/*
   设备详情界面处理
 */
@interface DeviceInfoViewController : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>

@property(nonatomic,strong) ELDeviceObject *deviceObject;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@property (weak, nonatomic) IBOutlet UINavigationBar *customBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *customItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtomItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightarButtomItem;

- (IBAction)leftOnClick:(id)sender;


- (IBAction)rightOnClick:(id)sender;

@end
