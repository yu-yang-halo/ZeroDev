//
//  LeftMenuViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "JSONManager.h"

@interface LeftMenuViewController (){
  
}
@property (nonatomic, strong) NSArray *contents;


@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView=[[SKSTableView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_tableView];
    
    self.tableView.SKSTableViewDelegate = self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    

    
    NSArray *tags=[JSONManager getMobileAppTags];
    //NSLog(@"tags %@",tags);
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
   
    
    
    
    
    self.navigationItem.title = @"SKSTableView";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Collapse"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self
                                                                             action:@selector(collapseSubrows)];
    [self setDataManipulationButton:UIBarButtonSystemItemRefresh];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    static NSString *CellIdentifier = @"UITableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (!cell)
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
     [cell setBackgroundColor:[UIColor clearColor]];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@", self.contents[indexPath.row][indexPath.subRow]];
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

#pragma mark - Actions

- (void)collapseSubrows
{
    [self.tableView collapseCurrentlyExpandedIndexPaths];
}

- (void)refreshData
{
    NSArray *array = @[
                       @[
                           @[@"Section0_Row0", @"Row0_Subrow1",@"Row0_Subrow2"],
                           @[@"Section0_Row1", @"Row1_Subrow1", @"Row1_Subrow2", @"Row1_Subrow3", @"Row1_Subrow4", @"Row1_Subrow5", @"Row1_Subrow6", @"Row1_Subrow7", @"Row1_Subrow8", @"Row1_Subrow9", @"Row1_Subrow10", @"Row1_Subrow11", @"Row1_Subrow12"],
                           @[@"Section0_Row2"]
                           ]
                       ];
    [self reloadTableViewWithData:array];
    
    [self setDataManipulationButton:UIBarButtonSystemItemUndo];
}

- (void)undoData
{
    [self reloadTableViewWithData:nil];
    
    [self setDataManipulationButton:UIBarButtonSystemItemRefresh];
}

- (void)reloadTableViewWithData:(NSArray *)array
{
    self.contents = array;
    
    // Refresh data not scrolling
    //    [self.tableView refreshData];
    
    [self.tableView refreshDataWithScrollingToIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

#pragma mark - Helpers

- (void)setDataManipulationButton:(UIBarButtonSystemItem)item
{
    switch (item) {
        case UIBarButtonSystemItemUndo:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo
                                                                                                  target:self
                                                                                                  action:@selector(undoData)];
            break;
            
        default:
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                                                  target:self
                                                                                                  action:@selector(refreshData)];
            break;
    }
}

@end


