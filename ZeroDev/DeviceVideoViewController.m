//
//  DeviceVideoViewController.m
//  ZeroDev
//
//  Created by admin on 16/1/30.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "DeviceVideoViewController.h"
#import "DeviceConfigViewController.h"
#import "MonitorViewController.h"
#import "EditWiFiViewController.h"
@interface DeviceVideoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceOnOrOffBtn;

@property(nonatomic,retain) MonitorViewController *monitorVC;

- (IBAction)playOrPauseAction:(id)sender;
- (IBAction)voiceOnOrOffAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UIButton *parameterConfigBtn;
- (IBAction)parameterConfigAction:(id)sender;

@end

@implementation DeviceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setTitle:_deviceObject.name];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backList)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"设置" style:UIBarButtonItemStylePlain target:self action:@selector(settings)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    
    [self.videoImageView setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.9]];
    
    NSString *uid=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_UID]];
    
    NSString *pass=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_PASSWORD]];
    
    self.monitorVC=[[MonitorViewController alloc] initUID:uid withPass:pass];
    [self.monitorVC recordCameraState:_statusLabel];
    [self.videoImageView setUserInteractionEnabled:YES];
    [self.videoImageView addSubview:_monitorVC.view];
    
   
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button click event
-(void)backList{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
     [self.monitorVC stop];
}
-(void)settings{
   
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main"
                                                             bundle: nil];
    DeviceConfigViewController *deviceConfigVC=[mainStoryboard instantiateViewControllerWithIdentifier:@"deviceConfigVC"];
    
    [deviceConfigVC setDeviceObject:_deviceObject];
    [self.navigationController pushViewController:deviceConfigVC animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(background) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(foreground) name:UIApplicationWillEnterForegroundNotification object:nil];
    [self loadLastDeviceData];
}
-(void)viewDidDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)background{
     [self.monitorVC playOrPause:NO];
}
-(void)foreground{
     [self.monitorVC playOrPause:YES];
}

-(void)loadLastDeviceData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        self.deviceObject=[[ElApiService shareElApiService] getObjectValue:_deviceObject.objectId];
        dispatch_async(dispatch_get_main_queue(), ^{
              NSString *uid=[self.deviceObject.fieldMap objectForKey:[NSString stringWithFormat:@"%d",IP_CAMERA_FILED_UID]];
              self.monitorVC.UID=uid;
             [self setTitle:_deviceObject.name];
             [self.monitorVC playOrPause:YES];

        });
    });
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.monitorVC playOrPause:NO];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)playOrPauseAction:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
    
    [self.monitorVC playOrPause:!sender.selected];
    
}

- (IBAction)voiceOnOrOffAction:(UIButton *)sender {
    if(sender.selected){
        [sender setSelected:NO];
    }else{
        [sender setSelected:YES];
    }
   
    if(sender.selected){
        [self.monitorVC.camera stopSoundToDevice:0];
        [self.monitorVC unactiveAudioSession];
        [self.monitorVC activeAudioSession:1];
        [self.monitorVC.camera startSoundToPhone:0];
    }else{
        [self.monitorVC.camera stopSoundToDevice:0];
        [self.monitorVC unactiveAudioSession];
        [self.monitorVC.camera stopSoundToPhone:0];
    }
}
- (IBAction)parameterConfigAction:(id)sender {
    EditWiFiViewController *editWifiVC=[[EditWiFiViewController alloc] init];
    [editWifiVC setCamera:_monitorVC.camera];
    [editWifiVC setDeviceObject:_deviceObject];
    [self.navigationController pushViewController:editWifiVC animated:YES];
}
@end
