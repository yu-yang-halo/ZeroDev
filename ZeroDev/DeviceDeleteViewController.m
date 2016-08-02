//
//  DeviceDeleteViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/26.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "DeviceDeleteViewController.h"
#import "AppManager.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppDelegate.h"
#import "JSONManager.h"
#import "DeviceVideoViewController.h"
#import <JSONKit/JSONKit.h>
#import "HYLClassUtils.h"
#import <ELNetworkService/ELNetworkService.h>
#import <SIAlertView/SIAlertView.h>
#import <UIView+Toast.h>
@interface DeviceDeleteViewController ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
}
@property (nonatomic,retain) NSDictionary *deviceDic;
@end

@implementation DeviceDeleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"删除设备";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"ic_drawer"] style:UIBarButtonItemStylePlain target:self action:@selector(slideMenuAction)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    

    [self.webView.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webView.scrollView setShowsVerticalScrollIndicator:NO];
    
    self.webView.delegate=self;
    self.webView.scrollView.delegate=self;
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webView.bounds.size.height,self.webView.bounds.size.width,self.webView.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webView.scrollView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];

    
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"deviceDel.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_deleteDevice"]=^(){
        NSArray *args=[JSContext currentArguments];
        int objectId=[args[0] toInt32];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self deleteDevice:objectId];
        });
        
    };
    
}

-(void)deleteDevice:(int)deviceId{
    
    SIAlertView *alertView=[[SIAlertView alloc] initWithTitle:@"提示" andMessage:@"是否删除该设备?"];
    [alertView addButtonWithTitle:@"取消" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        
    }];
    [alertView addButtonWithTitle:@"确定" type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           BOOL deleteYN=[[ElApiService shareElApiService] deleteObject:deviceId];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                if (deleteYN) {
                    [self.view makeToast:@"删除成功"];
                }else{
                    [self.view makeToast:@"删除失败"];
                }
                [self loadWebViewData];
                
            });
            
        });
    }];
    [alertView show];
    
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
-(void)loadWebViewData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.deviceDic=[[ElApiService shareElApiService] getObjectList];
        //搜集对象object json数据
        NSMutableArray *allDeviceObj=[NSMutableArray new];
        
        [self.deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
            
            if(obj.classId==IP_CAMERA_FILED_CLASSID){
                [obj setNetState:1];
            }
            NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
            [allDeviceObj addObject:objectMap];
            
            
        }];
        
        
        
        NSString *mobileAppJSON=[[JSONManager reverseMobileAppJSONToObject] JSONString];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if(_deviceDic!=nil&&[_deviceDic count]>0){
                [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_initTableData(%@,%@)",[allDeviceObj JSONString],mobileAppJSON]];
            }
            
            _reloading=NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
            
        });
    });
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark EGORefreshTableHeaderDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _reloading=YES;
    [self loadWebViewData];
}
-(BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view{
    return _reloading;
}
-(NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view{
    return [NSDate date];
}
#pragma mark UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
      [self loadWebViewData];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
}


@end

