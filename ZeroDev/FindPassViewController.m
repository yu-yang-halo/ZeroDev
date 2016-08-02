//
//  FindPassViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "FindPassViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import <UIView+Toast.h>
#import "JSONManager.h"
@interface FindPassViewController ()
{
    int appId;
}
@end

@implementation FindPassViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"密码找回";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"findpass.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_findPassCmd"]=^(){
        NSArray *args=[JSContext currentArguments];
        NSString *phoneOrEmail=[args[0] toString];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self findPassBy:phoneOrEmail];
        });
        
    };
    NSDictionary *applicationObj=applicationObj=[JSONManager reverseApplicationJSONToObject];
    appId=[[applicationObj objectForKey:@"localAppId"] intValue];
}

-(void)passwordResetByPhone:(NSString *)phone{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{

        BOOL isSUC=[[ElApiService shareElApiService] sendShortMsgCodeByUser:phone type:SHORT_MESSAGE_TYPE_PASS appId:appId];
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSUC){
               
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:@"找回密码不成功"];
            }
        });
    });
}
-(void)passwordResetByEmail:(NSString *)email{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
        NSString *randomPass=[Util getCharacterAndNumber:6];
        NSString *message=[[NSString alloc] initWithFormat:@"密码重置为:%@.为了您的账户安全 请尽快登录并至个人信息中修改.",randomPass];
        NSString *reverseMD5_pass=[WsqMD5Util getmd5WithString:randomPass];
        
        
        BOOL isSUC=[[ElApiService shareElApiService] sendEmailShortMsg:email withType:0 andText:message]&&[[ElApiService shareElApiService] updateUser:reverseMD5_pass email:email number:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(isSUC){
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [self.view makeToast:@"找回密码不成功"];
            }
        });
    });
}


-(void)findPassBy:(NSString *)phoneOrEmail{
    if(![Util isEmail:phoneOrEmail]&&![Util isMobileNumber:phoneOrEmail]){
        [self.view makeToast:@"请输入正确的手机号码或邮箱"];
    }else{
        if([Util isEmail:phoneOrEmail]){
            [self passwordResetByEmail:phoneOrEmail];
        }else if([Util isMobileNumber:phoneOrEmail]){
            [self passwordResetByPhone:phoneOrEmail];
        }
    }
    
}

-(void)back{
    [self.navigationController popViewControllerAnimated:YES];
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



