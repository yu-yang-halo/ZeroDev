//
//  DeviceDeleteViewController.h
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
/*
   设备删除处理
 */
@interface DeviceDeleteViewController : UIViewController<UIWebViewDelegate,EGORefreshTableHeaderDelegate,UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

