//
//  LoginViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/6.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "LoginViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import <UIView+Toast.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <ELNetworkService/ELNetworkService.h>
#import "AppManager.h"
#import "AppDelegate.h"
#import "JSONManager.h"
#import "QRCodeShowViewController.h"
const  NSString *kloginUserName=@"keyLoginUserName";
const  NSString *kloginPassword=@"keyLoginPassword";

@interface LoginViewController (){
    MBProgressHUD *hud;
 
    
    NSDictionary *applicationObj;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation LoginViewController




-(void)viewWillAppear:(BOOL)animated{
    
    
    
}
-(void)viewDidAppear:(BOOL)animated{
    [self initHtmlUserInfo];
}

-(void)initNavigationBar{
    [self.navigationController.navigationBar setHidden:NO];
    
   
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStylePlain target:self action:@selector(registerUser)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    self.navigationItem.title=[applicationObj objectForKey:@"localName"];
    
    UIButton *qrCodeBtn=[[UIButton alloc] initWithFrame:CGRectMake(0,0,44,44)];
    [qrCodeBtn setImage:[UIImage imageNamed:@"qr0"] forState:UIControlStateNormal];
    
    [qrCodeBtn addTarget:self action:@selector(QRCodeShow) forControlEvents:UIControlEventTouchUpInside];
    [qrCodeBtn setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-20)];
    [qrCodeBtn setTintColor:[UIColor whiteColor]];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithCustomView:qrCodeBtn];
    
    
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    applicationObj=[JSONManager reverseApplicationJSONToObject];
    
    [self initNavigationBar];
    
   
    
    
    
    [self loadHtmlContent];
    UIBarButtonItem *backButton=[[UIBarButtonItem alloc] init];
    [backButton setTitle:@"返回"];
    self.navigationItem.backBarButtonItem=backButton;
    
       
    
}


-(void)initHtmlUserInfo{
    
    NSString *username=[[NSUserDefaults standardUserDefaults] objectForKey:kloginUserName];
    
    NSString *password=[[NSUserDefaults standardUserDefaults] objectForKey:kloginPassword];
    
    if(username!=nil&&password!=nil){
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_setUsernamePassToView('%@','%@')",username,password]];
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initCheckBox(%@)",@"true"]];
    }else{
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"hyl_setUsernamePassToView('%@','%@')",@"",@""]];
        
        [self.webView stringByEvaluatingJavaScriptFromString:[NSString stringWithFormat:@"initCheckBox(%@)",@"false"]];
    }
    
}

-(void)requestIndexHtml{
    NSString *filePath=[[AppManager uiRootPath] stringByAppendingPathComponent:@"index.html"];
    NSLog(@"filePath %@",filePath);
    NSURL *url=[NSURL fileURLWithPath:filePath];
    
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

-(void)loadHtmlContent{
    
    self.webView.delegate=self;
    self.webView.scrollView.scrollEnabled=NO;
    
    [self requestIndexHtml];
    
    
    self.webView.dataDetectorTypes=UIDataDetectorTypeNone;
    
    JSContext *context=[self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"mobile_loadDefaultUsernamePass"]=^(){
        
        
    };
    
    context[@"mobile_login"]=^(){
        NSLog(@"objc_login....");
        
        NSArray *args=[JSContext currentArguments];
        for (JSValue *jsVal in args) {
            
            NSLog(@"argument : %@",jsVal.toString);
        }
        JSValue *thiz=[JSContext currentThis];
        
        NSLog(@"end....%@",thiz);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self asynlogin:[args[0] toString] withPass:[args[1] toString] isRemember:[args[2] toBool]];

        });
        
        
    };
}

-(void)saveUsername:(NSString *)name AndPassword:(NSString *)pass{
    [[NSUserDefaults standardUserDefaults] setObject:name forKey:kloginUserName];
    [[NSUserDefaults standardUserDefaults] setObject:pass forKey:kloginPassword];
}
-(void)clearUsernameAndPassword{
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginUserName];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kloginPassword];
    
}


-(void)asynlogin:(NSString *)name withPass:(NSString *)pass isRemember:(BOOL)isRem{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText=@"登录中...";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        int appId=[[applicationObj objectForKey:@"localAppId"] intValue];
        BOOL isOK=[[ElApiService shareElApiService] loginByUsername:name andPassword:pass appId:appId];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide:YES];
            if(isOK){
                
                if(isRem){
                    [self saveUsername:name AndPassword:pass];
                }else{
                    [self clearUsernameAndPassword];
                }
                
                
                AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
                [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES];
                
               
                
            
            }
            
            
            
        });
    });
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    //UIViewController *send=segue.destinationViewController;
}

#pragma mark Navigation BAR Click envent
-(void)QRCodeShow{
    QRCodeShowViewController *qrCodeShowVC=[[QRCodeShowViewController alloc] init];
    
    [self.navigationController pushViewController:qrCodeShowVC animated:YES];
    
    
}
-(void)registerUser{
    
}


#pragma mark delegate

- (void)webViewDidStartLoad:(UIWebView *)webView{
    hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [hud hide:YES];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [self.webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
    
    [self initHtmlUserInfo];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    NSLog(@"%@",error);
    [hud hide:YES];
}


@end

