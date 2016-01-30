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
@interface DeviceVideoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *videoImageView;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceOnOrOffBtn;

@property(nonatomic,retain) MonitorViewController *monitorVC;

- (IBAction)playOrPauseAction:(id)sender;
- (IBAction)voiceOnOrOffAction:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

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
    [self.videoImageView addSubview:_monitorVC.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Button click event
-(void)backList{
    [self.monitorVC stop];
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
    
}
-(void)settings{
    [self.monitorVC stop];
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

- (IBAction)playOrPauseAction:(id)sender {
    
}

- (IBAction)voiceOnOrOffAction:(id)sender {
    
}
@end
