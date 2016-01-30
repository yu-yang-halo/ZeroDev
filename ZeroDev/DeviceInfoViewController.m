//
//  DeviceInfoViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/24.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "DeviceInfoViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "AppManager.h"
#import "JSONManager.h"
#import <JSONKit/JSONKit.h>
#import "HYLClassUtils.h"
#import "AppDelegate.h"
#import "DeviceConfigViewController.h"
#import <UIView+Toast.h>
@interface DeviceInfoViewController ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    NSString *mobileAppJSON;
    BOOL _pageLoadFinished;
}
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setTitle:_deviceObject.name];
     self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backList)];
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    
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
    
    
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"device.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_setFieldCmd"]=^(){
   
       // fieldValue,fieldId,objectId
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            NSLog(@"argument : %@",jsVal.toString);
        }
        
        [self setFieldValue:[args[0] toString] fieldId:[args[1] toInt32] objectId:[args[2] toInt32]];
        
        
        
    };
    context[@"malert"]=^(){
         NSArray *args=[JSContext currentArguments];
         dispatch_async(dispatch_get_main_queue(), ^{
            
             [self.view makeToast:[args[0] toString]];
             
         });
    };
   
    
    
}
-(void)setFieldValue:(NSString *)value fieldId:(int)fieldId objectId:(int)objectId{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[ElApiService shareElApiService] setFieldValue:value forFieldId:fieldId toDevice:objectId withYN:YES];
        
    });
}
-(void)viewWillAppear:(BOOL)animated{
    if(_pageLoadFinished){
        [self loadLastDeviceData];
    }else{
        NSLog(@"页面还没加载完成，。。。");
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Button click event
-(void)backList{
     AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
}
-(void)settings{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DeviceConfigViewController *deviceConfigVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"deviceConfigVC"];
    
    [deviceConfigVC setDeviceObject:_deviceObject];
    [self.navigationController pushViewController:deviceConfigVC animated:YES];
    
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
     _pageLoadFinished=NO;
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    _pageLoadFinished=YES;
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
            NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:_deviceObject];
            
            [self.webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadData(%@,%@)",mobileAppJSON,[objectMap JSONString]]];
            
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
