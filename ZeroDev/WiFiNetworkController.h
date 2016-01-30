//
//  WiFiNetworkController.h
//  IOTCamViewer
//
//  Created by tutk on 12/27/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/AVIOCTRLDEFs.h>
#import <IOTCamera/Camera.h>
#import "EditWiFiPasswordController.h"

@protocol WiFiNetworkDelegate;

@interface WiFiNetworkController : UITableViewController <CameraDelegate, EditWiFiPasswordDelegate> {
    
    Camera *camera;
    SWifiAp wifiSSIDList[28];
    int wifiSSIDListCount;
    Boolean isRecvWiFi;
    Boolean isChangeWiFi;
    NSString *wifiSSID;
    
    id<WiFiNetworkDelegate> delegate;
	NSTimer* timerListWifiApResp;
	int nTotalWaitingTime;
	BOOL bRemoteDevTimeout;
	BOOL bTimerListWifiApResp;
	int nLastSelIdx;
}

@property (nonatomic, retain) NSTimer* timerListWifiApResp;
@property (nonatomic, retain) Camera *camera;
@property (nonatomic, copy) NSString *wifiSSID;
@property (nonatomic, weak) id<WiFiNetworkDelegate> delegate;

- (id)initWithStyle:(UITableViewStyle)style delegate:(id<WiFiNetworkDelegate>)delegate;
- (IBAction)back:(id)sender;

@end

@protocol WiFiNetworkDelegate

- (void)didChangeWiFiAp:(NSString *)wifiSSID;

@end