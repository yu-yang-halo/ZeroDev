//
//  LeftMenuViewController.h
//  ZeroDev
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *staticView;

@end

@interface GroupCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *expandImageView;

@end

@interface ChildCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
