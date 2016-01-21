//
//  HYLDevicesController.m
//  ehomeDebugTools
//
//  Created by admin on 15/6/12.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "HYLDevicesController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <ELNetworkService/ELNetworkService.h>
#import <objc/runtime.h>
#import <JSONKit/JSONKit.h>
#import <UIView+Toast.h>
#import "HYLClassUtils.h"
#import "AppManager.h"
#import "JSONManager.h"
#import "DeviceInfoViewController.h"
#import "AnimationUtils.h"
@interface HYLDevicesController (){
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    ELDeviceObject *selectedObject;
}
@property (strong, nonatomic) IBOutlet UIWebView *webVIew;
@property (nonatomic,retain) NSDictionary *deviceDic;

@end

@implementation HYLDevicesController
-(void)viewDidAppear:(BOOL)animated{
    NSLog(@"viewDidAppear..........");
    //获取web数据
    [self loadWebViewData];
    
}
-(void)toDeviceManager{
    NSLog(@"%s",__func__);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    [self.navigationController.navigationBar setHidden:NO];
    [self setTitle:[JSONManager getAppTitle]];
    
    
    [self.webVIew.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webVIew.scrollView setShowsVerticalScrollIndicator:NO];
    
    //self.webVIew.delegate=self;
    self.webVIew.scrollView.delegate=self;
    
    if(_refreshHeaderView==nil){
        _refreshHeaderView=[[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0,0-self.webVIew.bounds.size.height,self.webVIew.bounds.size.width,self.webVIew.bounds.size.height)];
        _refreshHeaderView.delegate=self;
        [self.webVIew.scrollView addSubview:_refreshHeaderView];
        
    }
    [_refreshHeaderView refreshLastUpdatedDate];
    
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"devices.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webVIew loadRequest:[NSURLRequest requestWithURL:url]];
    
    
    
    JSContext *context=[self.webVIew valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    
    context[@"mobile_toDetailPage"]=^(){
        NSArray *args=[JSContext currentArguments];
        
        NSLog(@"%@",[args[0] toString]);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            selectedObject=[[ElApiService shareElApiService] getObjectValue:[[args[0] toString] integerValue]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                         bundle: nil];
                DeviceInfoViewController *devInfoVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"deviceInfoVC"];
                
                
                [devInfoVC setDeviceObject:selectedObject];
                
                
                [self presentViewController:(DeviceInfoViewController *)devInfoVC animated:YES completion:^{
                    
                }];
                
            });
        });
        
        
    };

    
    static int count=0;
    context[@"mobile_requestDevices"]=^(){
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           
           self.deviceDic=[[ElApiService shareElApiService] getObjectList];
           //搜集对象object json数据
           NSMutableArray *allDeviceObj=[NSMutableArray new];
           //搜集类型class json数据  {classId：[fields{}] }
           NSMutableDictionary *allClassObjs=[NSMutableDictionary new];
            //搜集class icon
            NSMutableDictionary *classIcon=[NSMutableDictionary new];
            
            
           [self.deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
               
               
               
               NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
               
               [allDeviceObj addObject:objectMap];
               
           }];
            
           NSLog(@"%@",[allDeviceObj JSONString]);
           NSLog(@"=====================");
            NSLog(@"%@",[classIcon JSONString]);
        
            [HYLClassUtils cacheClasslistData:[allClassObjs JSONString]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(_deviceDic!=nil&&[_deviceDic count]>0){
                    [self.webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadDevicesData(%@,%@,%@)",[allDeviceObj JSONString],[allClassObjs JSONString],[classIcon JSONString]]];
                }
                
                _reloading=NO;
                [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webVIew.scrollView];
               
            });
        });
        
        
    };
    
    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
   
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
     [_webVIew stringByEvaluatingJavaScriptFromString:@"hyl_requestDevicesCmd()"];
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

- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
    return NO;
}
- (BOOL)slideNavigationControllerShouldDisplayLeftMenu{
    return YES;
}
#pragma mark MenuHandlerDelegate
-(void)menuClick:(MENU_CLICK_TYPE)type{
    
    NSString *identifier=nil;
    switch (type) {
        case MENU_CLICK_TYPE_DEVICE_MANAGER:
            identifier=@"deviceManagerVC";
            break;
        default:
            identifier=nil;
            break;
    }
    if(identifier!=nil){
        [self clickToViewController:identifier];
        
       
    }else{
        [[SlideNavigationController sharedInstance] closeMenuWithCompletion:^{
            
        }];
    }
    
}

-(void)clickToViewController:(NSString *)identifier{
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    UIViewController *vc=[mainStoryboard instantiateViewControllerWithIdentifier:identifier];
    
   
    [AnimationUtils addAnimationFromRight:vc.view.layer];

    [self presentViewController:vc animated:NO completion:^{
        
    }];
    

    
}

@end
