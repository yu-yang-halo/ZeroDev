//
//  LeftMenuViewController.h
//  ZeroDev
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
typedef NS_ENUM(NSInteger,MENU_CLICK_TYPE){
    MENU_CLICK_TYPE_DEVICE_LIST,
    MENU_CLICK_TYPE_DEVICE_MANAGER,
    MENU_CLICK_TYPE_USER_MANAGER
    /*
        可添加其他类型
     */
};

@protocol MenuHandlerDelegate<NSObject>


-(void)menuClick:(MENU_CLICK_TYPE)type;


@end

/*
   左侧菜单界面
 */
@interface LeftMenuViewController : UIViewController <SKSTableViewDelegate>

@property (retain, nonatomic) SKSTableView *tableView;


@end

