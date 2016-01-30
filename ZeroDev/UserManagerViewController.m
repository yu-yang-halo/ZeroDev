//
//  UserManagerViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "UserManagerViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import <UIView+Toast.h>
#import "RegexUtils.h"
#import "AppDelegate.h"
#import <SIAlertView/SIAlertView.h>
@interface UserManagerViewController ()
//userManagerVC
@end

@implementation UserManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"userManager.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    self.webView.delegate=self;
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
   
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_updateUserPass"]=^(){
        NSArray *args=[JSContext currentArguments];
        /*
          oldpass newpass repass
         */
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSString *mPass=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_PASSWORD];
            
            
            if(![RegexUtils isVaildPass:[args[1] toString]]){
                [self.view makeToast:@"密码至少为六位"];
            }else if(![[args[1] toString] isEqualToString:[args[2] toString]]){
                [self.view makeToast:@"两次输入密码不一致"];
            }else if(![mPass isEqualToString:[args[0] toString]]){
                [self.view makeToast:@"当前密码错误！！！"];
            }else{
                
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    BOOL updatePassYN=[[ElApiService shareElApiService] updateUser:[WsqMD5Util getmd5WithString:[args[1] toString]] email:nil number:nil];
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                       
                        if(updatePassYN){
                            SIAlertView *alerView=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"用户信息修改成功，请重新登录"];
                            [alerView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                                AppDelegate *delegate=[UIApplication sharedApplication].delegate;
                                [delegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
                            }];
                             [alerView show];
                            
                           
                        }else{
                            [self.view makeToast:@"用户信息修改失败"];
                        }
                        
                    });
                    
                });
            }
            
        });
        
    };
    context[@"mobile_updateUserInfo"]=^(){
        //username email telephone
        NSArray *args=[JSContext currentArguments];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(![Util isEmail:[args[1] toString]]){
                [self.view makeToast:@"邮箱格式不正确"];
            }else if(![Util isMobileNumber:[args[2] toString]]){
                [self.view makeToast:@"手机格式不正确"];
            }else{
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    BOOL updateUserInfoYN=[[ElApiService shareElApiService] updateUser:nil email:[args[1] toString] number:[args[2] toString]];
                    
                    dispatch_async(dispatch_get_main_queue(),^{
                        
                        if(updateUserInfoYN){
                            SIAlertView *alerView=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"密码修改成功，请重新登录"];
                            [alerView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
                                AppDelegate *delegate=[UIApplication sharedApplication].delegate;
                                [delegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
                            }];
                            [alerView show];
                            
                        }else{
                            [self.view makeToast:@"密码修改失败"];
                        }
                        
                    });
                    
                });
            }
            
        });
    };
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)refreshUserInfo{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       NSString *loginName=[[NSUserDefaults standardUserDefaults] objectForKey:KEY_LOGINNAME];
       ELUserInfo *userInfo=[[ElApiService shareElApiService] findUserInfo:loginName withEmail:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
           
            if(userInfo!=nil){
                [self.webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"initUserInfo('%@','%@','%@')",userInfo.loginName,userInfo.email,userInfo.phoneNumber]];
            }
            
            
        });
        
    });
}


- (IBAction)slideMenuAction:(id)sender {
    NSLog(@"sender : %@",sender);
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    if([[appDelegate sideMenuController] isLeftViewShowing]){
        [[appDelegate sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
            
        }];
    }else{
        [[appDelegate sideMenuController] showLeftViewAnimated:YES completionHandler:^{
            
        }];
    }
    
}

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [self refreshUserInfo];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end
