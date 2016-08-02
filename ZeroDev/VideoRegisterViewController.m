//
//  VideoRegisterViewController.m
//  ZeroDev
//
//  Created by admin on 16/2/17.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "VideoRegisterViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
#import <QRCodeReaderViewController.h>
#import <ELNetworkService/ELNetworkService.h>
#import "DeviceVideoViewController.h"
#import <UIView+Toast.h>
#import <MBProgressHUD/MBProgressHUD.h>
@interface VideoRegisterViewController ()
{
    int ccsClientId;
    int classId;
    MBProgressHUD *hud;
}
@end

@implementation VideoRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"添加视频";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_drawer"] style:UIBarButtonItemStylePlain target:self action:@selector(slideMenuAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"videoRegister.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_scanCode"]=^(){
        //2
        QRCodeReaderViewController * _reader = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消"];
        
        // Or by using blocks
        [_reader setCompletionWithBlock:^(NSString *resultAsString) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                //function loadScanCodeData(sn,clientId,classId)
                NSLog(@"register video data(sn:clientId:classId:uid ) %@", resultAsString);
                NSArray *registerDatas=[resultAsString componentsSeparatedByString:@":"];
                
                
                if([registerDatas count]==4){
                    ccsClientId= [registerDatas[1] intValue];
                    classId    = [registerDatas[2] intValue];
                    
                   [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadScanCodeData('%@','%@')",registerDatas[0],registerDatas[3]]];
                    
                }
                
                
            }];
        }];
        
        [self presentViewController:_reader animated:YES completion:NULL];
    };
    
    context[@"mobile_registerVideoDevice"]=^(){
        //sn,uid,username,password,name
        NSArray *args=[JSContext currentArguments];
        if([args count]==5){
            
           dispatch_async(dispatch_get_main_queue(), ^{
               hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
               [hud setLabelText:@"注册中..."];
               
               
               [self registerVideo:args];
           });
        }
        
    };
    context[@"malert"]=^(){
        NSArray *args=[JSContext currentArguments];
        NSString *alertMsg=[args[0] toString];
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(alertMsg!=nil){
                [self.view makeToast:alertMsg];
            }
            
        });
    };
    
}

-(void)registerVideo:(NSArray *)args{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int objectId=[[ElApiService shareElApiService] createObject:classId name:[args[4] toString] ccsClientSn:[args[0] toString] clientId:ccsClientId];
        BOOL regYN=NO;
        
        if(objectId>0){
            regYN=YES;
            regYN=[[ElApiService shareElApiService] setFieldValue:[args[1] toString] forFieldId:IP_CAMERA_FILED_UID toDevice:objectId withYN:YES]&&regYN;
            regYN=[[ElApiService shareElApiService] setFieldValue:[args[2] toString] forFieldId:IP_CAMERA_FILED_USERNAME toDevice:objectId withYN:YES]&&regYN;
            regYN=[[ElApiService shareElApiService] setFieldValue:[args[3] toString] forFieldId:IP_CAMERA_FILED_PASSWORD toDevice:objectId withYN:YES]&&regYN;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(hud!=nil){
                [hud hide:YES];
            }
            if(regYN){
                [self.view makeToast:@"注册成功"];
            }else{
                [self.view makeToast:@"注册失败"];
            }
        });
    });
}

- (void)slideMenuAction{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    if([[appDelegate sideMenuController] isLeftViewShowing]){
        [[appDelegate sideMenuController] hideLeftViewAnimated:YES completionHandler:^{
            
        }];
    }else{
        [[appDelegate sideMenuController] showLeftViewAnimated:YES completionHandler:^{
            
        }];
    }
    
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
