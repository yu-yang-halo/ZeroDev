//
//  LeftMenuViewController.m
//  ZeroDev
//
//  Created by admin on 15/11/9.
//  Copyright (c) 2015年 cn.lztech  &#21512;&#32933;&#32852;&#27491;&#30005;&#23376;&#31185;&#25216;&#26377;&#38480;&#20844;&#21496;. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "ZDItem.h"

@interface LeftMenuViewController (){
    NSArray *heads;
    NSArray *contents;
    
    NSInteger CellCount;
    NSInteger ExpandCount;
}
@property (assign, nonatomic) BOOL isExpand;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;


@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]];
    [self.staticView setBackgroundColor:[UIColor clearColor]];
    self.isExpand = NO;
    heads=[NSArray arrayWithObjects:@"0",@"1",@"2", nil];
    contents=[NSArray arrayWithObjects:[NSArray arrayWithObjects:@"01",@"02",@"03", nil],[NSArray arrayWithObjects:@"11",@"12", nil],[NSArray arrayWithObjects:@"23",nil], nil];
    
    CellCount=[heads count];
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.dataSource=self;
    self.tableView.delegate=self;
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Private

- (NSArray *)indexPathsForExpandRow:(NSInteger)row {
    NSMutableArray *indexPaths = [NSMutableArray array];
    for (int i = 1; i <= ExpandCount; i++) {
        NSIndexPath *idxPth = [NSIndexPath indexPathForRow:row + i inSection:0];
        [indexPaths addObject:idxPth];
    }
    return [indexPaths copy];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.isExpand) {
        return CellCount + ExpandCount;
    }
    return CellCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (self.isExpand && self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {   // Expand cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
        int childIndex=indexPath.row-self.selectedIndexPath.row-1;
        NSLog(@"childIndex:%d",childIndex);
        
        id title=[[contents objectAtIndex:self.selectedIndexPath.row] objectAtIndex:childIndex];
        
        [[(ChildCell *)cell titleLabel] setText:title];
    } else {    // Normal cell
        cell = [tableView dequeueReusableCellWithIdentifier:@"GroupCell" forIndexPath:indexPath];
        int groupIndex=indexPath.row;
       
        if(indexPath.row>=ExpandCount+self.selectedIndexPath.row+1){
            groupIndex=indexPath.row-ExpandCount;
        }
    
         NSLog(@"groupIndex:%d ",groupIndex);
        
        [[(GroupCell *)cell titleLabel] setText:[heads objectAtIndex:groupIndex]];
    }
    [cell setBackgroundColor:[UIColor clearColor]];
    UIView *view=[[UIView alloc] initWithFrame:cell.bounds];
    [view setAlpha:0.0];
    [cell setSelectedBackgroundView:view];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isExpand && self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {
        return 77;
    } else {
        return 77;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.selectedIndexPath) {
        ExpandCount=[[contents objectAtIndex:indexPath.row] count];
        self.isExpand = YES;
        self.selectedIndexPath = indexPath;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    } else {
        if (self.isExpand) {
            if (self.selectedIndexPath == indexPath) {
                [[(GroupCell *)[self.tableView cellForRowAtIndexPath:self.selectedIndexPath] expandImageView] setHighlighted:NO];
                
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:indexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
               
                
               
            } else if (self.selectedIndexPath.row < indexPath.row && indexPath.row <= self.selectedIndexPath.row + ExpandCount) {
                // Select the expand cell, do the relating dealing.
            } else {
                [[(GroupCell *)[self.tableView cellForRowAtIndexPath:indexPath] expandImageView] setHighlighted:NO];
                self.isExpand = NO;
                [self.tableView beginUpdates];
                [self.tableView deleteRowsAtIndexPaths:[self indexPathsForExpandRow:self.selectedIndexPath.row] withRowAnimation:UITableViewRowAnimationTop];
                [self.tableView endUpdates];
                self.selectedIndexPath = nil;
                
            }
        }
    }
}

@end


@implementation GroupCell

@end

@implementation ChildCell

@end
