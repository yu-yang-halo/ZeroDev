//
//  EditWiFiViewController.m
//  ehomeStrong
//
//  Created by admin on 15/12/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import "EditWiFiViewController.h"
#import "WiFiNetworkController.h"
@interface EditWiFiViewController (){
    MyCamera *camera;
    NSTimer* timerListWifiApResp;
    int nTotalWaitingTime;
    BOOL bTimerListWifiApResp;
}
@property (retain, nonatomic) IBOutlet UILabel *wifiSSIDLabel;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *wifiActivityIndicator;
@property (retain, nonatomic) IBOutlet UIView *statusView;
@property(retain,nonatomic) NSString *wifiSSID;

@property (retain, nonatomic) IBOutlet UITextField *uidTextField;

@property (retain, nonatomic) IBOutlet UITextField *accTextField;

@property (retain, nonatomic) IBOutlet UITextField *pwdTextField;

@end

@implementation EditWiFiViewController
@synthesize camera;
- (void)viewDidLoad {
    [super viewDidLoad];
   
   
    self.title=@"WiFi参数";
    [self.navigationController setNavigationBarHidden:NO];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(close)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toNetWork:)];
    [tap setNumberOfTapsRequired:1];
    [_statusView addGestureRecognizer:tap];
    
    
    [_wifiActivityIndicator startAnimating];
    
    NSString *uid=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_UID]];
    NSString *acc=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_USERNAME]];
    NSString *pass=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_PASSWORD]];
    [self.uidTextField setText:uid];
    [self.accTextField setText:acc];
    [self.pwdTextField setText:pass];
    self.uidTextField.delegate=self;
    self.accTextField.delegate=self;
    self.pwdTextField.delegate=self;
}


-(void)toNetWork:(id)sender{
    WiFiNetworkController *controller = [[WiFiNetworkController alloc] initWithStyle:UITableViewStyleGrouped delegate:self];
    controller.camera = camera;
    
    if (self.wifiSSID != nil)
        controller.wifiSSID = self.wifiSSID;
    else
        controller.wifiSSID = nil;
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)initCameraInfo{
    
        [Camera initIOTC];
         camera.delegate2=self;
         [camera connect:camera.name];
         [camera start:0];
    
        
        SMsgAVIoctrlGetAudioOutFormatReq *s = (SMsgAVIoctrlGetAudioOutFormatReq *)malloc(sizeof(SMsgAVIoctrlGetAudioOutFormatReq));
        s->channel = 0;
        [camera sendIOCtrlToChannel:0 Type:IOTYPE_USER_IPCAM_GETAUDIOOUTFORMAT_REQ Data:(char *)s DataSize:sizeof(SMsgAVIoctrlGetAudioOutFormatReq)];
        free(s);

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
-(void)viewDidAppear:(BOOL)animated{
     [self initCameraInfo];
}
-(void)closeCameraConnection{
    if(camera!=nil){
        [camera stop:0];
        [camera disconnect];
        [camera setDelegate2:nil];
        [camera release];
    }
}

- (void)didChangeWiFiAp:(NSString *)wifiSSID{
    _wifiSSIDLabel.text=wifiSSID;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_wifiSSIDLabel release];
    [_wifiActivityIndicator release];
    [_statusView release];
    [super dealloc];
}
-(void)close{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self closeCameraConnection];
        NSString *uid=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_UID]];
        NSString *acc=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_USERNAME]];
        NSString *pass=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_PASSWORD]];
        if(![self.uidTextField.text isEqualToString:uid]&&![Util isEmpty:self.uidTextField.text]){
            [[ElApiService shareElApiService] setFieldValue:self.uidTextField.text forFieldId:IP_CAMERA_FILED_UID toDevice:_deviceObject.objectId withYN:YES];
        }
        if(![self.accTextField.text isEqualToString:acc]&&![Util isEmpty:self.accTextField.text]){
            [[ElApiService shareElApiService] setFieldValue:self.accTextField.text forFieldId:IP_CAMERA_FILED_USERNAME toDevice:_deviceObject.objectId withYN:YES];
        }
        if(![self.pwdTextField.text isEqualToString:pass]&&![Util isEmpty:self.pwdTextField.text]){
            [[ElApiService shareElApiService] setFieldValue:self.pwdTextField.text forFieldId:IP_CAMERA_FILED_PASSWORD toDevice:_deviceObject.objectId withYN:YES];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
}

- (void)camera:(MyCamera *)camera _didChangeSessionStatus:(NSInteger)status
{
    switch (status) {
        case CONNECTION_STATE_CONNECTED:
           
            [self getWifiInfo];
            
            break;
            
        case CONNECTION_STATE_CONNECTING:
            
            break;
            
        case CONNECTION_STATE_DISCONNECTED:
            NSLog(@"CONNECTION_STATE_DISCONNECTED");
            break;
            
        case CONNECTION_STATE_CONNECT_FAILED:
       
            
            break;
            
        case CONNECTION_STATE_TIMEOUT:
            
            break;
            
        case CONNECTION_STATE_UNKNOWN_DEVICE:
         
            break;
            
        case CONNECTION_STATE_UNSUPPORTED:
            
            break;
            
        case CONNECTION_STATE_WRONG_PASSWORD:
             
            break;
            
        default:
            
            break;
    }
    
}

- (void)camera:(MyCamera *)camera _didReceiveIOCtrlWithType:(NSInteger)type Data:(const char *)data DataSize:(NSInteger)size
{
    NSLog(@"didReceiveIOCtrlWithType %d %s",type,data);
    if (type == IOTYPE_USER_IPCAM_LISTWIFIAP_RESP) {
        NSLog(@"**********IOTYPE_USER_IPCAM_LISTWIFIAP_RESP********");
        
        SMsgAVIoctrlListWifiApResp *s = (SMsgAVIoctrlListWifiApResp *)data;
        int wifiStatus = 0;
        
        NSLog( @"AP num:%d", s->number );
        for (int i = 0; i < s->number; ++i) {
            
            SWifiAp ap = s->stWifiAp[i];
            NSLog( @" [%d] ssid:%s, mode => %d, enctype => %d, signal => %d%%, status => %d", i, ap.ssid, ap.mode, ap.enctype, ap.signal, ap.status );
            if (ap.status == 1 || ap.status == 2 || ap.status == 3 || ap.status == 4) {
                 self.wifiSSID = [NSString stringWithCString:ap.ssid encoding:NSUTF8StringEncoding];
                wifiStatus = ap.status;
                NSLog(@"wifiStatus %d wifiSSID %@",wifiStatus,_wifiSSID);
                _wifiSSIDLabel.text=_wifiSSID;
                if(_wifiActivityIndicator!=nil){
                    [_wifiActivityIndicator stopAnimating];
                    [_wifiActivityIndicator removeFromSuperview];
                }
            }
            
        }
        
        if (s->number>0&&wifiStatus==0) {
            _wifiSSIDLabel.text=@"您还没有设置WIFI";
            if(_wifiActivityIndicator!=nil){
                [_wifiActivityIndicator stopAnimating];
                [_wifiActivityIndicator removeFromSuperview];
            }
        }
        
        
    }
}
-(void)getWifiInfo {
    NSLog(@"***** wifi info****");
    // get WiFi info
    SMsgAVIoctrlListWifiApReq *structWiFi = malloc(sizeof(SMsgAVIoctrlListWifiApReq));
    memset(structWiFi, 0, sizeof(SMsgAVIoctrlListWifiApReq));
    
    bTimerListWifiApResp = TRUE;
    nTotalWaitingTime = 0;
    timerListWifiApResp = [[NSTimer scheduledTimerWithTimeInterval:30.0 target:self selector:@selector(timeOutGetListWifiAPResp:) userInfo:[NSNumber numberWithInt:30] repeats:FALSE] retain];
    [camera sendIOCtrlToChannel:0
                           Type:IOTYPE_USER_IPCAM_LISTWIFIAP_REQ
                           Data:(char *)structWiFi
                       DataSize:sizeof(SMsgAVIoctrlListWifiApReq)];
    free(structWiFi);
}

- (void)timeOutGetListWifiAPResp:(NSTimer *)timer
{
    
    bTimerListWifiApResp = FALSE;
    
    int timeOut = [(NSNumber*)timer.userInfo intValue];
    nTotalWaitingTime += timeOut;
    
    NSLog( @"!!! IOTYPE_USER_IPCAM_LISTWIFIAP_RESP TimeOut %dsec !!!", nTotalWaitingTime );
    
    if( nTotalWaitingTime <= 30 ) {
        timeOut = 20;
    }
    else if( nTotalWaitingTime <= 50 ) {
        timeOut = 10;
    }
    else if( nTotalWaitingTime > 50 ) {
        timeOut = 0;
       
        _wifiSSIDLabel.text=@"已超时,无法获取";
        if(_wifiActivityIndicator!=nil){
            [_wifiActivityIndicator stopAnimating];
            [_wifiActivityIndicator removeFromSuperview];
        }
       

    }
    
    [timerListWifiApResp release];
    
    if( timeOut > 0 ) {
        bTimerListWifiApResp = TRUE;
        timerListWifiApResp = [[NSTimer scheduledTimerWithTimeInterval:timeOut target:self selector:@selector(timeOutGetListWifiAPResp:) userInfo:[NSNumber numberWithInt:timeOut] repeats:FALSE] retain];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if( bTimerListWifiApResp ) {
        [timerListWifiApResp invalidate];
        [timerListWifiApResp release];
        bTimerListWifiApResp = FALSE;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
