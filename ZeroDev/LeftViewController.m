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
@property(nonatomic,strong)   NSArray        *contents;
@property(nonatomic,strong)   NSMutableArray *tagsArr;
@property(nonatomic,strong)   NSArray        *tags;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    self.tableView.SKSTableViewDelegate = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView.tableFooterView setFrame:CGRectZero];
    [self.tableView.tableHeaderView setFrame:CGRectZero];
    
    
    self.tags=[JSONManager getMobileAppTags];

    NSArray *menuDataArr=@[
                           @[@"主页"],
                           @[@"设备管理",@"添加设备",@"添加视频",@"删除设备"],
                           @[@"用户信息"],
                           @[@"关于"],
                           @[@"退出"]
                           ];
    
    self.tagsArr=[[NSMutableArray alloc] init];
    for (NSDictionary *localTag in _tags) {
        NSMutableArray *singleContainer=[[NSMutableArray alloc] init];
        NSArray *tag=[localTag objectForKey:@"localTag"];
        NSString *name=[localTag objectForKey:@"localName"];
        [singleContainer addObject:name];
        [singleContainer addObjectsFromArray:tag];
        [_tagsArr addObject:singleContainer];
    }
    
    if([_tagsArr count]>0){
        NSMutableArray *allMenuDataArr=[[NSMutableArray alloc] init];
        
        for(int j=0;j<[menuDataArr count];j++){
            if(j==1){
                for (int i=0;i<[_tagsArr count];i++) {
                    [allMenuDataArr addObject:[_tagsArr objectAtIndex:i]];
                }
            }
            [allMenuDataArr addObject:[menuDataArr objectAtIndex:j]];
            
            
        }
        
        NSLog(@"allMenuDataArr %@",allMenuDataArr);
        self.contents=allMenuDataArr;
    }else{
        self.contents=menuDataArr;
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
    UIView *selectedBg=[[UIView alloc] initWithFrame:cell.frame];
    [selectedBg setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.2]];
    [cell setSelectedBackgroundView:selectedBg];
    
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
    UIColor *selectedColor=[UIColor colorWithRed:153/255.0 green:204/255.0 blue:0.0 alpha:1];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *selectedBg=[[UIView alloc] initWithFrame:cell.frame];
    [selectedBg setBackgroundColor:[UIColor colorWithWhite:0.6 alpha:0.2]];
    [cell setSelectedBackgroundView:selectedBg];
    
   // cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
   
    if(indexPath.row==[_tagsArr count]+1){
        NSNumber *subRowValue=[[NSUserDefaults standardUserDefaults] objectForKey:kZeroDevDeviceManagerKey];
        if([subRowValue intValue]==indexPath.subRow){
            [cell.textLabel setTextColor:selectedColor];
        }
    }
    
    if(_tags!=nil
       &&[_tags count]>0
       &&indexPath.row>=1
       &&indexPath.row<=[_tags count]){
     
        NSDictionary *tag=[self.tags objectAtIndex:(indexPath.row-1)];
        
        NSString *tagSetIdWithTag=[[NSUserDefaults standardUserDefaults] objectForKey:kZeroDevTagSetIdWithTagKey];
        if(tagSetIdWithTag!=nil){
            NSArray *tagSetIdWithTagArr=[tagSetIdWithTag componentsSeparatedByString:@":"];
            if([tagSetIdWithTagArr count]==2){
                
                if(([tagSetIdWithTagArr[0] intValue]==[[tag objectForKey:@"localTagSetId"] intValue])&&[[[tag objectForKey:@"localTag"] objectAtIndex:(indexPath.subRow-1)] isEqualToString:tagSetIdWithTagArr[1]]){
                    
                    [cell.textLabel setTextColor:selectedColor];
                }
            }
            
            
        }
        
    }
    
    
    return cell;
}

- (CGFloat)tableView:(SKSTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Row : Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
    [self determineEventType:indexPath.row subRow:indexPath.subRow isParent:YES];
}

- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"SubRow : Section: %d, Row:%d, Subrow:%d", indexPath.section, indexPath.row, indexPath.subRow);
    [self determineEventType:indexPath.row subRow:indexPath.subRow isParent:NO];
    
}

-(void)determineEventType:(int)row subRow:(int)subRow isParent:(BOOL)parentYN{
    AppDelegate *appDelegate=[[UIApplication sharedApplication] delegate];
    BOOL hasChildNodeYN=NO;
    
    if(parentYN){
        if(row==[_tagsArr count]+1){
            if(subRow==0){
                hasChildNodeYN=YES;
            }
        }else if(row!=0&&row!=([_tagsArr count]+4)&&row!=([_tagsArr count]+2)&&row!=([_tagsArr count]+3)){
            if(subRow==0){
                hasChildNodeYN=YES;
            }
        }
        
    }
    if(!hasChildNodeYN){
        [[appDelegate sideMenuController] hideLeftViewAnimated:!parentYN completionHandler:^{
            
        }];
    }
    
    
    
    if(row==0){
        NSLog(@"主页");
       [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kZeroDevTagSetIdWithTagKey];
       [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kZeroDevDeviceManagerKey];
        [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_MAIN animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
        [self.tableView reloadData];
        
        
    }else if(row==[_tagsArr count]+1){
        NSLog(@"设备管理");
        
        if(subRow!=0){
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kZeroDevTagSetIdWithTagKey];
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:subRow] forKey:kZeroDevDeviceManagerKey];
            [self.tableView reloadData];
         
            if(subRow==1){
                [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_ADD_DEVICE animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
            }else if(subRow==2){
                [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_ADD_VIDEO animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
            }else if(subRow==3){
                [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_DELETE_DEVICE animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
            }
        }
        
        
    }else if(row==[_tagsArr count]+2){
        NSLog(@"用户信息");
        
        [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_USER_INFO animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
    }else if(row==[_tagsArr count]+3){
        NSLog(@"关于");
       
        [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_ABOUT animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];
    }else if(row==[_tagsArr count]+4){
        NSLog(@"退出");
      
        [appDelegate setRootViewController:ROOT_VIEWCONTROLLER_TYPE_LOGIN animated:YES animationType:ZERO_DEV_ANIMATION_TYPE_POP];
    }else{
        NSLog(@"TAG row %d, subRow %d %@",row,subRow,[[self.contents objectAtIndex:row] objectAtIndex:subRow]);
       
        if(subRow!=0){
            NSDictionary *tag=[self.tags objectAtIndex:(row-1)];
            
            NSString *tagSetId=[tag objectForKey:@"localTagSetId"];
            NSString *tagContent=[[tag objectForKey:@"localTag"] objectAtIndex:(subRow-1)];
            NSLog(@"tagsetId :%@ tagCOntent:%@",tagSetId,tagContent);
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kZeroDevDeviceManagerKey];
            [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@:%@",tagSetId,tagContent] forKey:kZeroDevTagSetIdWithTagKey];
            
            [self.tableView reloadData];
            
            [self.pageDelegate swicthToPage:SWITCH_PAGE_TYPE_MAIN animationType:ZERO_DEV_ANIMATION_TYPE_PUSH];

        }
    }
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
