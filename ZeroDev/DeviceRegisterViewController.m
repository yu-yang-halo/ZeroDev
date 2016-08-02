//
//  DeviceRegisterViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "DeviceRegisterViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
#import <QRCodeReaderViewController.h>
#import <UIView+Toast.h>
#import <ELNetworkService/ELNetworkService.h>
#import "JSONManager.h"
#import <JSONKit/JSONKit.h>
#import "HYLClassUtils.h"
@interface DeviceRegisterViewController ()
{
    ELCcsClientInfo *ccsInfo;
}
@end

@implementation DeviceRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title=@"添加设备";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_drawer"] style:UIBarButtonItemStylePlain target:self action:@selector(slideMenuAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"deviceRegister.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
     self.webView.delegate=self;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_scanCode"]=^(){
        //1
        QRCodeReaderViewController * _reader = [QRCodeReaderViewController readerWithCancelButtonTitle:@"取消"];
        
        // Or by using blocks
        [_reader setCompletionWithBlock:^(NSString *resultAsString) {
            
            [self dismissViewControllerAnimated:YES completion:^{
                //function loadScanCodeData(sn,clientId,classId)
                NSLog(@"register device data(clientId,sn,classId ) %@", resultAsString);
                NSArray *registerDatas=[resultAsString componentsSeparatedByString:@","];
                
                
                if([registerDatas count]==3){
                     ccsInfo=[[ELCcsClientInfo alloc] init];
                    [ccsInfo setClientId:[registerDatas[0] intValue]];
                    [ccsInfo setClientSn:registerDatas[1]];
                    [ccsInfo setClassId:[registerDatas[2] intValue]];
                    
                    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadScanCodeData('%@',%d,%d)",ccsInfo.clientSn,ccsInfo.clientId,ccsInfo.classId]];
                    
                }
                
                
            }];
        }];
        
        [self presentViewController:_reader animated:YES completion:NULL];
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
    context[@"mobile_hylSearchClientSn"]=^(){
        NSArray  *args=[JSContext currentArguments];
        NSString *clientSN=[args[0] toString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
            ccsInfo=[[ElApiService shareElApiService] getCcsDeviceBySn:clientSN];
            
            id jsonObj=[HYLClassUtils canConvertJSONDataFromObjectInstance:ccsInfo];
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"loadClsInfosAndCcsDeviceInfo(%@)",[jsonObj JSONString]]];
                
                
            });
        
        });
        
    };
    context[@"mobile_registerDevice"]=^(){
        NSArray *args=[JSContext currentArguments];
        //sn name
        NSString *sn=[args[0] toString];
        NSString *name=[args[1] toString];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            int objectId=-1;
            if(ccsInfo!=nil&&[ccsInfo.clientSn isEqualToString:sn]){
               objectId=[[ElApiService shareElApiService] createObject:ccsInfo.classId name:name ccsClientSn:ccsInfo.clientSn clientId:ccsInfo.clientId];
                
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if(objectId>0){
                    [self.view makeToast:@"设备注册成功"];
                }else{
                    [self.view makeToast:@"设备注册失败"];
                }
            });
         
        });
    };
    
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


    NSDictionary *classJSONObj=[JSONManager reverseClassJSONToObject];
    [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"cacheClsInfos(%@)",[classJSONObj JSONString]]];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end

