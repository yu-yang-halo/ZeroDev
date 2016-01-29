//
//  DeviceConfigViewController.m
//  ZeroDev
//
//  Created by admin on 16/1/29.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "DeviceConfigViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppManager.h"
#import "JSONManager.h"
#import <JSONKit/JSONKit.h>
#import "HYLClassUtils.h"
#import "AppDelegate.h"
#import <UIView+Toast.h>
@interface DeviceConfigViewController ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSString *mobileAppJSON;
}
@end
@implementation DeviceConfigViewController
-(void)viewDidLoad{
    [self setTitle:_deviceObject.name];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backDeviceInfo)];
   
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    mobileAppJSON=[[JSONManager reverseMobileAppJSONToObject] JSONString];
    
    
    self.webView.delegate=self;
    
    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    
    
    self.webView.scrollView.delegate=self;
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webView.bounds.size.height,self.webView.bounds.size.width,self.webView.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webView.scrollView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"deviceConfig.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_updateDeviceInfo"]=^(){
        NSArray *args=[JSContext currentArguments];
        //sn,name,tagArrString  1-->name
        [self updateDeviceInfoData:[args[1] toString]  tagArr:[args[2] toString]];
    };
}
-(void)updateDeviceInfoData:(NSString *)name  tagArr:(NSString *)tagArrString{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL updataYN=YES;
        NSArray *tagArr=[tagArrString componentsSeparatedByString:@","];
        for (NSString *sTag in tagArr) {
            NSArray *tagSetIdWithTag=[sTag componentsSeparatedByString:@":"];
            if ([tagSetIdWithTag count]==2) {
                int tagSetId=[tagSetIdWithTag[0] intValue];
                NSString *tagContent=tagSetIdWithTag[1];
                if(tagSetId>0&&![tagContent isEqualToString:@"未选择"]){
                   BOOL addTagYN=[[ElApiService shareElApiService] addTagToDevObject:_deviceObject.objectId tagSetId:tagSetId tag:tagContent];
                    updataYN=(addTagYN&&updataYN);
                }
            }
        }
        
        if(![[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] isEqualToString:@""]&&![name isEqualToString:_deviceObject.name]){
            [_deviceObject setName:name];
            BOOL updateNameYN=[[ElApiService shareElApiService] updateObject:_deviceObject];
            updataYN=(updateNameYN&&updataYN);
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if(updataYN){
                [self.view makeToast:@"保存成功"];
            }else{
                [self.view makeToast:@"保存失败"];
            }
            [self loadLastDeviceData];
        });
        
        
        
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button click event
-(void)backDeviceInfo{
    [self.navigationController popViewControllerAnimated:YES];
}



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self.webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"init(%@)",mobileAppJSON]];
    
    [self loadWebViewData];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


#pragma mark scrollviewdelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}
-(void)loadWebViewData{
    if(_deviceObject!=nil){
      
        self.title=_deviceObject.name;
        
        NSArray *tags=_deviceObject.tags;
        NSMutableArray *tagArr=[[NSMutableArray alloc] init];
        for(ELTagInfo *tagInfo in tags){
            [tagArr addObject:[HYLClassUtils canConvertJSONDataFromObjectInstance:tagInfo]];
        }
        
        [self.webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"initNameAndSn('%@','%@',%@)",_deviceObject.name,_deviceObject.clientSn,[tagArr JSONString]]];
        
    }
    _reloading=NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
}
-(void)loadLastDeviceData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.deviceObject=[[ElApiService shareElApiService] getObjectValue:_deviceObject.objectId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self loadWebViewData];
        });
    });
}

#pragma mark EGORefreshTableHeaderDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _reloading=YES;
    [self loadLastDeviceData];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}


@end
