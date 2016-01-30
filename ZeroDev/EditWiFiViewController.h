//
//  EditWiFiViewController.h
//  ehomeStrong
//
//  Created by admin on 15/12/15.
//  Copyright (c) 2015年 cn.lztech  合肥联正电子科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/Camera.h>
#import <IOTCamera/Monitor.h>
#import "CameraShowGLView.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "WiFiNetworkController.h"
@interface EditWiFiViewController : UIViewController<CameraDelegate,WiFiNetworkDelegate>


@end
