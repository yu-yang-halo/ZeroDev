//
//  DeviceManagerViewController.h
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
    设备管理界面---【 设备注册，设备删除... 】
 */
@interface DeviceManagerViewController : UIViewController<UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@property (weak, nonatomic) IBOutlet UINavigationBar *customBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *customItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtomItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightarButtomItem;

- (IBAction)leftOnClick:(id)sender;


- (IBAction)rightOnClick:(id)sender;

@end
