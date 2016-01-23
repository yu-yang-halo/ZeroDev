//
//  LeftViewController.m
//  ZeroDev
//
//  Created by admin on 16/1/23.
//  Copyright (c) 2016年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "LeftViewController.h"
#import "JSONManager.h"
@interface LeftViewController ()
@property (nonatomic, strong) NSArray *contents;
@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.tableView.SKSTableViewDelegate = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView.tableFooterView setFrame:CGRectZero];
    [self.tableView.tableHeaderView setFrame:CGRectZero];
    
    
    NSArray *tags=[JSONManager getMobileAppTags];

    NSArray *menuDataArr=@[
                           @[@"主页"],
                           @[@"设备管理",@"添加设备",@"添加视频",@"删除设备"],
                           @[@"用户信息"],
                           @[@"关于"],
                           @[@"退出"]
                           ];
    
    NSMutableArray *tagContainer=[[NSMutableArray alloc] init];
    for (NSDictionary *localTag in tags) {
        NSMutableArray *singleContainer=[[NSMutableArray alloc] init];
        NSArray *tag=[localTag objectForKey:@"localTag"];
        NSString *name=[localTag objectForKey:@"localName"];
        [singleContainer addObject:name];
        [singleContainer addObjectsFromArray:tag];
        [tagContainer addObject:singleContainer];
    }
    
    if([tagContainer count]>0){
        NSMutableArray *allMenuDataArr=[[NSMutableArray alloc] init];
        
        for(int j=0;j<[menuDataArr count];j++){
            if(j==1){
                for (int i=0;i<[tagContainer count];i++) {
                    [allMenuDataArr addObject:[tagContainer objectAtIndex:i]];
                }
            }
            [allMenuDataArr addObject:[menuDataArr objectAtIndex:j]];
            
            
        }
        
        NSLog(@"allMenuDataArr %@",allMenuDataArr);
        self.contents=allMenuDataArr;
    }
    
    
    
    
    
    
}


#pragma mark - Private

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contents count];
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.contents[indexPath.row] count] - 1;
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0)
    {
        return YES;
    }
    
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"SKSTableViewCell";
    
    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell)
        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.text = self.contents[indexPath.row][0];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    if ([self.contents[indexPath.row] count]>1)
        cell.expandable = YES;
    else
        cell.expandable = NO;
    
    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath
{
     [tableView setBackgroundColor:[UIColor clearColor]];
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
