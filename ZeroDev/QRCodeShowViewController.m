//
//  QRCodeShowViewController.m
//  ZeroDev
//
//  Created by admin on 16/1/29.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "QRCodeShowViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AppDelegate.h"
const static NSString *QR_PARSE_API_URL=@"http://qr.liantu.com/api.php?text=%@";
@interface QRCodeShowViewController ()

@end

@implementation QRCodeShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"我的应用";
    [self.view setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.4]];
    
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backLogin)];
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"更换" style:UIBarButtonItemStylePlain target:self action:@selector(change)];
    
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    
    NSString *QRCodeURLPath=[[NSUserDefaults standardUserDefaults] objectForKey:kZeroDevAppQRCodePathKey];
    
    NSString *requestURL=[NSString stringWithFormat:QR_PARSE_API_URL,QRCodeURLPath];
    NSLog(@"requestURL %@",requestURL);
    SDWebImageDownloader *downloader=[SDWebImageDownloader sharedDownloader];
    [downloader downloadImageWithURL:[NSURL URLWithString:requestURL] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
    } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
        if(image!=nil&&finished){
            [self.qrCodeImageView setImage:image];
        }
    }];
    
}
-(void)backLogin{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)change{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_HOME animated:YES];
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

@end
