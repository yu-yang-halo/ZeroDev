//
//  HomeViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HomeViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppManager.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <UIView+Toast.h>
#import <QRCodeReaderViewController/QRCodeReaderViewController.h>
#import "AppDelegate.h"

#import "LoginViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setHidden:YES];
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    NSString *filePath=[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"ui/home.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_downloadApp"]=^(){
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        
        
        
    };
    context[@"mobile_scanCode"]=^(){
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        int typeCode=[[args lastObject] toInt32];
        //typecode ==0  URL   ==1 clientSN
        
        QRCodeReaderViewController * _reader = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消"];
        
        // Or by using blocks
        [_reader setCompletionWithBlock:^(NSString *resultAsString) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                NSLog(@"install app URL  %@", resultAsString);
                if(resultAsString!=nil){
                    [self beginDownloadApp:resultAsString];
                }
                
            }];
        }];
        
        [self presentViewController:_reader animated:YES completion:NULL];
        
    };
    context[@"mobile_demoLogin"]=^(){
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        
        int demoType=[[args lastObject] toInt32];
        NSString *username=@"hylapp1";
        NSString *password=@"hylapp1";
        NSString *demoURLString=@"http://121.41.15.186/iplusweb/upload/22/hylapp1.zip";
        if(demoType==0){
            username=@"hylapp0";
            password=@"hylapp0";
            demoURLString=@"http://121.41.15.186/iplusweb/upload/21/hylapp0.zip";
        }
        [[NSUserDefaults standardUserDefaults] setObject:username forKey:kloginUserName];
        [[NSUserDefaults standardUserDefaults] setObject:password forKey:kloginPassword];
       
        [self beginDownloadApp:demoURLString];
        
    };
    
   
    
}
-(void)beginDownloadApp:(NSString *)url{
    dispatch_async(dispatch_get_main_queue(), ^{
       
         MBProgressHUD *hub=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
         [hub setLabelText:@"安装中..."];
         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [AppManager downloadApp:url block:^(BOOL isSuc) {
                [hub hide:YES];
                if(isSuc){
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"activeYN"];
                    [[NSUserDefaults standardUserDefaults] setObject:url forKey:kZeroDevAppQRCodePathKey];
                    
                    AppDelegate* appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
                                        
                    
                }else{
                    [self.view makeToast:@"安装失败，请检查网络状态" duration:1 position:CSToastPositionBottom];
                }
                
            }];
        });
        
    });
   
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
