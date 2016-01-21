//
//  ModalView.h
//  ZeroDev
//
//  Created by admin on 15/11/25.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModalView : UIView
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *customBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *customItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *leftBarButtonItem;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@end
