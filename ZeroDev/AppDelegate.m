//
//  AppDelegate.m
//  ZeroDev
//
//  Created by admin on 15/11/6.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "AppDelegate.h"
#import "AppManager.h"
#import "JSONManager.h"
#import "CustomNavigationController.h"
#import "LeftViewController.h"
#import <ELNetworkService/ELNetworkService.h>
#import <UIView+Toast.h>
@interface AppDelegate ()
{
    CustomNavigationController *customNavVC;
    LeftViewController *leftMenu;
    LGSideMenuController *sideMenuController;
    
}
@property(nonatomic,strong) UIView *lunchView;

@end

@implementation AppDelegate

@synthesize lunchView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   NSLog(@"didFinishLaunchingWithOptions 0");
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
   
    BOOL activeYN=[[NSUserDefaults standardUserDefaults] boolForKey:@"activeYN"];
    
    application.statusBarStyle=UIStatusBarStyleLightContent;
    
    leftMenu=[[LeftViewController alloc] init];
    leftMenu.pageDelegate=self;
    CGRect frame= self.window.frame;
    frame.size.width=200.f;
    leftMenu.view.frame=frame;
    
    [leftMenu.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.6]];
    sideMenuController = [[LGSideMenuController alloc] init];
    
    [sideMenuController setLeftViewEnabledWithWidth:200.f
                                  presentationStyle:LGSideMenuPresentationStyleSlideAbove
                               alwaysVisibleOptions:0];
    sideMenuController.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
    sideMenuController.leftViewStatusBarVisibleOptions = LGSideMenuStatusBarVisibleOnAll;
    
    [sideMenuController.leftView addSubview:leftMenu.view];
    
    
    if(activeYN){
        
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:NO animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
        
      
        
        lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
        lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width,
                                     self.window.screen.bounds.size.height);
        [self.window addSubview:lunchView];
        
         NSDictionary *mobilApp=[JSONManager reverseMobileAppJSONToObject];
         NSString *startPage=[mobilApp objectForKey:@"localStartPage"];
        
         NSString *realImagePath=[[AppManager imgRootPath] stringByAppendingPathComponent:startPage];
        
         NSLog(@"realImagePath %@",realImagePath);
        
         UIImage *launchImage=[UIImage imageWithContentsOfFile:realImagePath];
         lunchView.layer.contents=(__bridge id)launchImage.CGImage;
         lunchView.layer.contentsScale=launchImage.scale;
         lunchView.layer.contentsGravity=kCAGravityResizeAspectFill;
        
        
        
         [self.window bringSubviewToFront:lunchView];
        
         [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
         customNavVC.view.alpha=0;
    }else{
        
         [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_HOME animated:NO animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
        
          customNavVC.view.alpha=1;
    }
  
   
    [self.window makeKeyAndVisible];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showTips:) name:kErrorAlertNotification object:nil];
    
    return YES;
}

-(void)showTips:(NSNotification *)notification{
    NSString *errorMsg=[[notification userInfo] objectForKey:kErrorCodeKey];
    
    [self.window makeToast:errorMsg];
}
-(void)setUpSideMenuViewController:(UIViewController *)rootVC{
   
    CustomNavigationController *mainNavigationVC=[[CustomNavigationController alloc] initWithRootViewController:rootVC];
    [sideMenuController setRootViewController:mainNavigationVC];
    
}


-(void)removeLun {
    
    [UIView transitionWithView:lunchView duration:0.5 options:(UIViewAnimationOptionCurveEaseIn) animations:^{
        //CGRect frame=lunchView.frame;
        //frame.origin=CGPointMake(-frame.size.width,0);
        lunchView.alpha=0.0;
        customNavVC.view.alpha=1;
       // lunchView.frame=frame;
    } completion:^(BOOL finished) {
        
        [lunchView removeFromSuperview];
    }];
    
}
-(void)setRootViewController2:(UIViewController *)vc animated:(BOOL)animateYN animationType:(ZERO_DEV_ANIMATION_TYPE)animationType{
    customNavVC=[[CustomNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController=customNavVC;
    [self transitionViewAnimation:animationType animated:animateYN];
}
-(void)setRootViewController:(ROOT_VIEWCONTROLLER_TYPE)type animated:(BOOL)animateYN animationType:(ZERO_DEV_ANIMATION_TYPE)animationType{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *homeVC=[storyBoard instantiateViewControllerWithIdentifier:@"homeVC"];
    UIViewController *loginVC=[storyBoard instantiateViewControllerWithIdentifier:@"loginVC"];
     UIViewController *userManagerVC=[storyBoard instantiateViewControllerWithIdentifier:@"userManagerVC"];
    
   
    
    switch (type) {
        case ROOT_VIEWCONTROLLER_TYPE_HOME:
        {
             customNavVC=[[CustomNavigationController alloc] initWithRootViewController:homeVC];
             self.window.rootViewController=customNavVC;
        }
            break;
        case ROOT_VIEWCONTROLLER_TYPE_LOGIN:
        {
            customNavVC=[[CustomNavigationController alloc] initWithRootViewController:loginVC];
             self.window.rootViewController=customNavVC;
        }
            break;
        case ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE:{
            UIViewController *devicesVC=[storyBoard instantiateViewControllerWithIdentifier:@"devicesVC"];
            
            [self setUpSideMenuViewController:devicesVC];
            
            self.window.rootViewController=sideMenuController;
            

        }
            break;
        case ROOT_VIEWCONTROLLER_TYPE_ABOUT:{
           
//            [self setUpSideMenuViewController:loginVC];
//            
//            self.window.rootViewController=sideMenuController;
        }
            break;
        case ROOT_VIEWCONTROLLER_TYPE_USERINFO:
        {
            [self setUpSideMenuViewController:userManagerVC];
            
            self.window.rootViewController=sideMenuController;
            
        }
            break;
      
    }
    
    [self transitionViewAnimation:animationType animated:animateYN];
   
   
}

-(void)transitionViewAnimation:(ZERO_DEV_ANIMATION_TYPE)animationType animated:(BOOL)animateYN{
    if(animateYN){
        CGRect frame=_window.frame;
        if(animationType==ZERO_DEV_ANIMATION_TYPE_PUSH){
            frame.origin.x=frame.size.width;
        }else{
            frame.origin.x=-frame.size.width;
        }
        
        _window.frame=frame;
        
        [UIView transitionWithView:_window
                          duration:0.3
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:^{
                            _window.frame=[UIScreen mainScreen].bounds;
                        }
                        completion:nil];
        
    }
}


-(void)swicthToPage:(SWITCH_PAGE_TYPE)pageType animationType:(ZERO_DEV_ANIMATION_TYPE)type{
   
    if(pageType==SWITCH_PAGE_TYPE_USER_INFO){
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_USERINFO animated:YES animationType:type];
    }else if(pageType==SWITCH_PAGE_TYPE_MAIN){
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES animationType:type];
    }
    
}

-(LGSideMenuController *)sideMenuController{
    return sideMenuController;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"applicationWillResignActive 1");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"applicationDidEnterBackground 2");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"applicationWillEnterForeground 3");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"applicationDidBecomeActive 4");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"applicationWillTerminate 5");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kErrorAlertNotification object:nil];
}

@end
