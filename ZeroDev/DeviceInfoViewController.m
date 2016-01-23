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
@interface DeviceInfoViewController ()
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
}
@end

@implementation DeviceInfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    

    [self.view setBackgroundColor:[UIColor purpleColor]];
    
    [self.customBar setBarTintColor:[UIColor purpleColor]];
    
    [self.customItem setTitle:_deviceObject.name];
    
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
    context[@"mobile_downloadApp"]=^(){
                
    };
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    
//    [self.webView stringByEvaluatingJavaScriptFromString: [NSString stringWithFormat:@"loadData(%@,%d)",[JSONManager reverseJSONToString],_deviceObject.classId]];
    
    _reloading=NO;
    [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.webView.scrollView];
}

#pragma mark EGORefreshTableHeaderDelegate
-(void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view{
    _reloading=YES;
    [self performSelector:@selector(loadWebViewData) withObject:nil afterDelay:1];
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

- (IBAction)leftOnClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (IBAction)rightOnClick:(id)sender {
}
@end
