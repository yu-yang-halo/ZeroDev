//
//  AboutViewController.m
//  ZeroDev
//
//  Created by admin on 16/2/17.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "AboutViewController.h"
#import "JSONManager.h"
#import "AppDelegate.h"
@interface AboutViewController ()

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title=@"关于";
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];

    NSDictionary *applicationObj=[JSONManager reverseApplicationJSONToObject];
    NSString *aboutText=[applicationObj objectForKey:@"localAbout"];
    NSString *version=[applicationObj objectForKey:@"localVersion"];
    NSString *appName=[applicationObj objectForKey:@"localName"];
    
    if (aboutText==nil||[aboutText isEqualToString:@""]) {
        aboutText=@"合肥联正电子科技有限公司";
    }
    [self.textView setText:[NSString stringWithFormat:@"应用:  %@ (version %@)\n\n\n\n   %@",appName,version,aboutText]];
    
}

-(void)back{
    AppDelegate *appDelegate=[UIApplication sharedApplication].delegate;
    [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LISTDEIVCE animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
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
