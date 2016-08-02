//
//  UserRegisterViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import <UIView+Toast.h>
#import "RegexUtils.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "JSONManager.h"
@interface UserRegisterViewController ()
{
    NSDictionary *applicationObj;
}
@end

@implementation UserRegisterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.title=@"用户注册";
     self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    applicationObj=[JSONManager reverseApplicationJSONToObject];
    
    
    [self loadHtmlContent];
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)requestIndexHtml{
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"register.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)loadHtmlContent{
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    [self requestIndexHtml];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_registerUserInfo"]=^(){
        /*
           username,pass,repass
         */
        NSArray *args=[JSContext currentArguments];
        NSString *username = [args[0] toString];
        NSString *password = [args[1] toString];
        NSString *repass   = [args[2] toString];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *email=nil;
            NSString *telephone=nil;
            if([Util isEmpty:username]){
                [self.view makeToast:@"用户名不能为空"];
            }else if(![RegexUtils isVaildPass:password]){
                [self.view makeToast:@"密码至少为6位"];
            }else if(![password isEqualToString:repass]){
                [self.view makeToast:@"两次输入密码不一致"];
            }else if(![Util isEmail:username]&&![Util isMobileNumber:username]){
                [self.view makeToast:@"用户名格式不正确"];
            }else{
                if([Util isEmail:username]){
                    email=username;
                }else{
                    telephone=username;
                }
             MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
             [hub setLabelText:@"注册中..."];
             
              dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  int appId=[[applicationObj objectForKey:@"localAppId"] intValue];
                  BOOL resultYN= [[ElApiService shareElApiService] createUser:username password:password email:email phoneNumber:telephone appId:appId];
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [hub hide:YES];
                      if(resultYN){
                        [self.view makeToast:@"注册成功"];
                        [self performSelector:@selector(back) withObject:nil afterDelay:1];
                      }else{
                        [self.view makeToast:@"注册失败"];
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

#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end


