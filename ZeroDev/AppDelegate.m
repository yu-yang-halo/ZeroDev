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
@interface AppDelegate ()
{
    
}
@property(nonatomic,strong) UIView *lunchView;

@end

@implementation AppDelegate

@synthesize lunchView;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
   
    [self.window makeKeyAndVisible];
    lunchView = [[NSBundle mainBundle ]loadNibNamed:@"LaunchScreen" owner:nil options:nil][0];
    lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width,
                                 self.window.screen.bounds.size.height);
    [self.window addSubview:lunchView];
    UIImage *launchImage=nil;
    if(launchImage==nil){
        launchImage=[UIImage imageNamed:@"launchLogo"];
    }
    
    lunchView.layer.contents=(__bridge id)launchImage.CGImage;
    lunchView.layer.contentsScale=launchImage.scale;
    lunchView.layer.contentsGravity=kCAGravityResizeAspectFill;
    
    [AppManager downloadApp:@"http://121.41.15.186/iplusweb/upload/hylapp1.zip" block:^(BOOL isSuc) {
        if(isSuc){
            NSLog(@"下载成功");
        }
    }];
    
    [self.window bringSubviewToFront:lunchView];
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    
    
   
    
   
    
    
    
    
    return YES;
}


-(void)removeLun {
    [lunchView removeFromSuperview];
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
