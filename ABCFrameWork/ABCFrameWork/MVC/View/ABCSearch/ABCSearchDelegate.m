//
//  ABCSearchDelegate.m
//  ABCFrameWork
//
//  Created by Robert on 15/4/29.
//  Copyright (c) 2015年 NationSky. All rights reserved.
//

#import "ABCSearchDelegate.h"
#import "ABCSearchTableCell.h"

@interface ABCSearchDelegate ()

@property (nonatomic, strong) NSMutableArray *sectionTitles;

@property (nonatomic, strong) NSMutableArray *searchItems;

@property (nonatomic, strong) UILabel *shadeLabel;

@property (nonatomic, strong) ABCSearchTagView *searchTagsView;

@end

@implementation ABCSearchDelegate

- (void)dealloc {
    [self.searchTagsView removeFromSuperview];
    self.searchTagsView = nil;
    
    [self.shadeLabel removeFromSuperview];
    self.shadeLabel = nil;
}

+ (instancetype)shareInstance {
    static ABCSearchDelegate *sharedDelegate;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDelegate = [[self alloc] init];
    });
    return sharedDelegate;
}

- (id)init {
    self = [super init];
    if (self) {
        self.searchItems = [NSMutableArray array];
        self.sectionTitles = [NSMutableArray arrayWithObjects:@"contactPerson",@"group",@"conversations", nil];
    }
    return self;
}

#pragma mark - searchBarDelegate and searchDisplayController
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    [self.searchItems removeAllObjects];
    self.searchTagsView = [[ABCSearchTagView alloc]initWithFrame:CGRectMake(0, 64, KSCREENWIDTH, KSCREENHEIGHT - 64) tagsArrar:@[@"1",@"22",@"333",@"4444",@"55555",@"666666",@"7777777",@"88888888",@"999999999",@"0000000000",@"1",@"22",@"333",@"4444",@"55555",@"666666",@"7777777",@"88888888",@"999999999",@"0000000000"]];
    self.searchTagsView.delegate = self;
    [ABCAppDelegate.window addSubview:self.searchTagsView];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    //添加遮挡视图
    self.shadeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KSCREENWIDTH, 20)];
    self.shadeLabel.backgroundColor = [UIColor colorWithRed:242/255.0 green:241/255.0 blue:249/255.0 alpha:1];
    [ABCAppDelegate.window addSubview:self.shadeLabel];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.searchTagsView removeFromSuperview];
    self.searchTagsView = nil;
    
    [self.shadeLabel removeFromSuperview];
    self.shadeLabel = nil;
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    return YES;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    UIView *topView = searchBar.subviews[0];
    for (UIView *subView in topView.subviews)
    {
        if ([subView isKindOfClass:[UIButton class]])
        {
            UIButton *cannelButton = (UIButton*)subView;
            [cannelButton setTitleEdgeInsets:UIEdgeInsetsMake(4, -4, 0, 0)];
            [cannelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        }
    }
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    UITableView *tableView1 = controller.searchResultsTableView;
    for( UIView *subview in tableView1.subviews )
    {
        if( [subview class] == [UILabel class] )
        {
            UILabel *lbl = (UILabel*)subview;
            lbl.text = @"noResult";
        }
    }
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSCharacterSet *white = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *text = [searchText stringByTrimmingCharactersInSet:white];
    if ([text isEqualToString:@""]) {
        self.searchTagsView.hidden = NO;
        return;
    }
    else {
        self.searchTagsView.hidden = YES;
    }
    //检索算法
}

#pragma mark - tableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchItems.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70;
}

static NSString *identifier = @"cellIdentifier";
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ABCSearchTableCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [ABCSearchTableCell initViewFromXIB];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - ABCSearchTagViewDelegate
- (void)theTagsContent:(NSString *)tagsContent {
    
}

@end
