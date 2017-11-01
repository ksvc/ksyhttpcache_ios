//
//  CacheSettingsViewController.m
//  demo
//
//  Created by sujia on 2016/11/13.
//  Copyright © 2016年 kingsoft. All rights reserved.
//

#import "CacheSettingsViewController.h"
#import <KSYHTTPCache/KSYHTTPProxyService.h>
#import <KSYHTTPCache/HTTPCacheDefines.h>

#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )

@interface CacheSettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) UITableView* tableView;
@property(nonatomic,strong) NSMutableArray* cacheSize;
@property(nonatomic,strong) NSMutableArray* cacheCount;
@property(nonatomic,strong) UINavigationBar *nav;

@property(nonatomic, assign) NSInteger selectedSection;
@property(nonatomic, assign) NSInteger selcctedRow;

@end

@implementation CacheSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationbar];
    
    [self initTableView];
}

-(void)initArray {
    NSMutableArray *sizeArray = [[NSMutableArray alloc] init];
    [sizeArray addObject:@[@"5M", [NSNumber numberWithLongLong:5*1024*1024]]];
    [sizeArray addObject:@[@"50M", [NSNumber numberWithLongLong:50*1024*1024]]];
    [sizeArray addObject:@[@"500M", [NSNumber numberWithLongLong:500*1024*1024]]];
    _cacheSize = sizeArray;
    
    NSMutableArray *countArray = [[NSMutableArray alloc] init];
    [countArray addObject:@[@"2", [NSNumber numberWithInteger:2]]];
    [countArray addObject:@[@"50", [NSNumber numberWithInteger:50]]];
    [countArray addObject:@[@"500", [NSNumber numberWithInteger:500]]];
    _cacheCount = countArray;
    
    //获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    _selectedSection = [userDefaults integerForKey:@"selected_section"];
    _selcctedRow = [userDefaults integerForKey:@"selected_row"];
}

-(void)initTableView {
    [self initArray];
    CGRect frame = CGRectMake(0, self.nav.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height - self.nav.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setNavigationbar
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44)];
    
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"缓存设置"];
    [self.nav pushNavigationItem:navigationBarTitle animated:YES];
    
    [self.view addSubview: self.nav];
    
    //创建UIBarButton 可根据需要选择适合自己的样式
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(navigationBackButton)];
    //设置barbutton
    navigationBarTitle.leftBarButtonItem = back;
    
    [self.nav setItems:[NSArray arrayWithObject: navigationBarTitle]];
}

-(void)navigationBackButton {
    [self dismissViewControllerAnimated:FALSE completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"限制缓存区文件大小";
    } else {
        return @"限制缓存区文件个数";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        if (section == 0) {
            return _cacheSize.count;
        } else {
            return _cacheSize.count;
        }
    } else {
        if (section == 0) {
            return _cacheSize.count - 1;
        } else {
            return _cacheSize.count - 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == _selectedSection && row == _selcctedRow) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    if (section == 0) {
        cell.textLabel.text = _cacheSize[row][0];
    } else {
        cell.textLabel.text = _cacheCount[row][0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSNumber *value = nil;
    if (section == 0) {
        value = _cacheSize[row][1];
        [[KSYHTTPProxyService sharedInstance] setMaxCacheSizeLimited: [value longLongValue]];
    } else {
        value = _cacheCount[row][1];
        [[KSYHTTPProxyService sharedInstance] setMaxFilesCountLimited:[value intValue]];
    }
    
    //获得NSUserDefaults文件
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    //2.向文件中写入内容
    [userDefaults setInteger:section forKey:@"selected_section"];
    [userDefaults setInteger:row forKey:@"selected_row"];
    //立即同步
    _selectedSection = section;
    _selcctedRow = row;
    [userDefaults synchronize];
    
    [tableView reloadData];
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView cellForRowAtIndexPath:indexPath].accessoryType = UITableViewCellAccessoryNone;
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
