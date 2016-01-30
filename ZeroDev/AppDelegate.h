//
//  AppDelegate.h
//  ZeroDev
//
//  Created by admin on 15/11/6.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//
typedef NS_ENUM(NSUInteger,ROOT_VIEWCONTROLLER_TYPE){
    ROOT_VIEWCONTROLLER_TYPE_HOME,
    ROOT_VIEWCONTROLLER_TYPE_LOGIN,
    ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE,
    ROOT_VIEWCONTROLLER_TYPE_ABOUT,
    ROOT_VIEWCONTROLLER_TYPE_USERINFO,
};
typedef NS_ENUM(NSUInteger,ZERO_DEV_ANIMATION_TYPE){
    ZERO_DEV_ANIMATION_TYPE_PUSH,
    ZERO_DEV_ANIMATION_TYPE_POP,
};

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"
#import "LeftViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate,PageSwitchDelegate>

@property (strong, nonatomic) UIWindow *window;


-(void)setRootViewController:(ROOT_VIEWCONTROLLER_TYPE)type animated:(BOOL)animateYN animationType:(ZERO_DEV_ANIMATION_TYPE)animationType;

-(void)setRootViewController2:(UIViewController *)vc animated:(BOOL)animateYN animationType:(ZERO_DEV_ANIMATION_TYPE)animationType;

-(LGSideMenuController *)sideMenuController;


@end

