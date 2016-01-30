//
//  EditWiFiPasswordController.h
//  IOTCamViewer
//
//  Created by tutk on 12/29/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IOTCamera/Camera.h>

@protocol EditWiFiPasswordDelegate;

@interface EditWiFiPasswordController : UIViewController 
<UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, CameraDelegate> {
    
    UITableView *tableView;
    UITextField *textFieldBeingEdited;
    NSString *ssid;
        
    int ssid_length;
    char mode;
    char enctype;
    
    Camera *camera;
    
    id<EditWiFiPasswordDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textFieldBeingEdited;
@property (nonatomic, retain) Camera *camera;
@property (nonatomic, copy) NSString *ssid;
@property (nonatomic) int ssid_length;
@property (nonatomic) char mode;
@property (nonatomic) char enctype;
@property (nonatomic, retain) id<EditWiFiPasswordDelegate> delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil delegate:(id<EditWiFiPasswordDelegate>)delegate;
- (IBAction)join:(id)sender;
- (IBAction)cancel:(id)sender;

@end

@protocol EditWiFiPasswordDelegate

- (void)didSetPasswordSuccess:(NSString *)ssid;

@end
