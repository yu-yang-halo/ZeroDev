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
        
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:NO];
        
      
        
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
        
         [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_HOME animated:NO];
        
          customNavVC.view.alpha=1;
    }
  
   
    [self.window makeKeyAndVisible];
    
    return YES;
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
-(void)setRootViewController2:(UIViewController *)vc animated:(BOOL)animateYN{
    customNavVC=[[CustomNavigationController alloc] initWithRootViewController:vc];
    self.window.rootViewController=customNavVC;
    if(animateYN){
        [UIView transitionWithView:_window
                          duration:0.8
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
    }
}
-(void)setRootViewController:(ROOT_VIEWCONTROLLER_TYPE)type animated:(BOOL)animateYN{
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *homeVC=[storyBoard instantiateViewControllerWithIdentifier:@"homeVC"];
    UIViewController *loginVC=[storyBoard instantiateViewControllerWithIdentifier:@"loginVC"];
    
   
    
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
           
            [self setUpSideMenuViewController:loginVC];
            
            self.window.rootViewController=sideMenuController;
        }
            break;
      
    }
   
    if(animateYN){
        [UIView transitionWithView:_window
                          duration:0.8
                           options:UIViewAnimationOptionTransitionCrossDissolve
                        animations:nil
                        completion:nil];
    }
}


-(void)swicthToPage:(SWITCH_PAGE_TYPE)pageType{
   
    if(pageType==SWITCH_PAGE_TYPE_ABOUT){
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_ABOUT animated:YES];
    }else if(pageType==SWITCH_PAGE_TYPE_MAIN){
        [self setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES];
    }
    
}

-(LGSideMenuController *)sideMenuController{
    return sideMenuController;
}

- (void)applicationWillResignActive:(UIApplication *)application {

}

- (void)applicationDidEnterBackground:(UIApplication *)application {

}

- (void)applicationWillEnterForeground:(UIApplication *)application {
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
}

@end
