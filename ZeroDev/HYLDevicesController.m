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
#import "AppDelegate.h"
#import "DeviceVideoViewController.h"
#import "RegexUtils.h"
@interface HYLDevicesController (){
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    ELDeviceObject *selectedObject;
    NSString *mobileAppJSON;
}
@property (strong, nonatomic) IBOutlet UIWebView *webVIew;
@property (nonatomic,retain) NSDictionary *deviceDic;
@property (nonatomic,retain) NSString *titleName;

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

- (void)viewDidLoad {
    [super viewDidLoad];
       
    
    [self.navigationController.navigationBar setHidden:NO];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"WIFI设置" style:UIBarButtonItemStylePlain target:self action:@selector(WIFIConfig)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
   
    mobileAppJSON=[[JSONManager reverseMobileAppJSONToObject] JSONString];
    
    [self.webVIew.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.webVIew.scrollView setShowsVerticalScrollIndicator:NO];
    
    self.webVIew.delegate=self;
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
        //objectID clientSn
        NSLog(@"%@",[args[0] toString]);
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            selectedObject=[[ElApiService shareElApiService] getObjectValue:[[args[0] toString] integerValue]];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                                         bundle: nil];
                 AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
                if([RegexUtils isVideoDevice:[args[1] toString]]){
                    DeviceVideoViewController *deviceVC=[[DeviceVideoViewController alloc] init];
                    [deviceVC setDeviceObject:selectedObject];
                    [appDelegate setRootViewController2:deviceVC animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
                }else{
                    DeviceInfoViewController *devInfoVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"deviceInfoVC"];
                    
                    [devInfoVC setDeviceObject:selectedObject];
                     [appDelegate setRootViewController2:devInfoVC animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
                }
                
                
                
                
                
               
               
                
                
            });
        });
        
        
    };

    

    
    

    
    
}
-(void)WIFIConfig{
    
    UIStoryboard *storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *wifiModule=[storyBoard instantiateViewControllerWithIdentifier:@"wifiModule"];
    AppDelegate *appDelegate=(AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate setRootViewController2:wifiModule animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
    
    
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
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.deviceDic=[[ElApiService shareElApiService] getObjectList];
        //搜集对象object json数据
        NSMutableArray *allDeviceObj=[NSMutableArray new];
        //搜集类型class json数据  {classId：[fields{}] }
        NSMutableDictionary *allClassObjs=[NSMutableDictionary new];
        //搜集class icon
        NSMutableDictionary *classIcon=[NSMutableDictionary new];
        NSString *tagSetIdWithTag=[[NSUserDefaults standardUserDefaults] objectForKey:kZeroDevTagSetIdWithTagKey];
        
        [self.deviceDic enumerateKeysAndObjectsUsingBlock:^(id key, ELDeviceObject* obj, BOOL *stop) {
            
            if(obj.classId==IP_CAMERA_FILED_CLASSID){
                [obj setNetState:1];
            }
            if(tagSetIdWithTag!=nil){
                
               NSArray *tagSetIdWithTagArr=[tagSetIdWithTag componentsSeparatedByString:@":"];
                if([tagSetIdWithTagArr count]==2){
                   
                    int tagSetId=[tagSetIdWithTagArr[0] intValue];
                    NSString *tagContent=tagSetIdWithTagArr[1];
                      self.titleName=tagContent;
                    BOOL isThisTagYN=NO;
                    for(ELTagInfo *tagInfo in obj.tags){
                        if(tagInfo.setTagId==tagSetId&&[tagInfo.tag isEqualToString:tagContent]){
                            isThisTagYN=YES;
                          
                        }
                    }
                    if(isThisTagYN){
                        NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
                        
                        [allDeviceObj addObject:objectMap];
                    }
                    
                }
                
            }else{
                 self.titleName=@"设备列表";
                NSMutableDictionary *objectMap=[HYLClassUtils canConvertJSONDataFromObjectInstance:obj];
                
                [allDeviceObj addObject:objectMap];
            }
            
            
        }];
        
        
        
        NSLog(@"=====================allDeviceObj %@ mobileAppJSON:%@",[allDeviceObj JSONString],mobileAppJSON);
   
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.title=_titleName;
            if(_deviceDic!=nil&&[_deviceDic count]>0){
                [self.webVIew stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_loadDevicesData(%@,%@)",[allDeviceObj JSONString],mobileAppJSON]];
            }
            
            _reloading=NO;
            [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webVIew.scrollView];
            
        });
    });

    
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


- (void)webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"webViewDidStartLoad...");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"webViewDidFinishLoad...");
    [self loadWebViewData];
}




@end
