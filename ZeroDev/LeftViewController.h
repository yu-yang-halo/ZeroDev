//
//  LeftViewController.h
//  ZeroDev
//
//  Created by admin on 16/1/23.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "SKSTableViewCell.h"
typedef NS_ENUM(NSUInteger,SWITCH_PAGE_TYPE){
    SWITCH_PAGE_TYPE_MAIN,
    SWITCH_PAGE_TYPE_ADD_DEVICE,
    SWITCH_PAGE_TYPE_ADD_VIDEO,
    SWITCH_PAGE_TYPE_DELETE_DEVICE,
    SWITCH_PAGE_TYPE_USER_INFO,
    SWITCH_PAGE_TYPE_ABOUT
};

@protocol PageSwitchDelegate

-(void)swicthToPage:(SWITCH_PAGE_TYPE)pageType;

@end


@interface LeftViewController : UIViewController<SKSTableViewDelegate>

@property (weak, nonatomic) IBOutlet SKSTableView *tableView;
@property(nonatomic,weak) id<PageSwitchDelegate> pageDelegate;

@end
