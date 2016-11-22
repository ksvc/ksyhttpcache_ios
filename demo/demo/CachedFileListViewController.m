//
//  CachedFileListViewController.m
//  HTTPCacheDemo
//
//  Created by sujia on 2016/11/10.
//  Copyright © 2016年 kingsoft. All rights reserved.
//

#import "CachedFileListViewController.h"
#import <KSYHTTPCache/KSYHTTPProxyService.h>
#import <KSYHTTPCache/HTTPCacheDefines.h>
#import <KSYMediaPlayer/KSYMediaInfoProber.h>
#import "KSYPlayerVC.h"

#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )
@interface CachedFileListViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray* cachedFiles;
@property(nonatomic,strong) UINavigationBar *nav;


@end

@implementation CachedFileListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavigationbar];
    
    [self initTableView];
}

-(void)initTableView {
    //self.cachedFiles = [[KSYHTTPProxyService sharedInstance] getAllCachedFileListWithError:nil];
    
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
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"已缓存完成文件列表"];
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
    
    self.cachedFiles = [[KSYHTTPProxyService sharedInstance] getAllCachedFileListWithError:nil];
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        return self.cachedFiles.count;
    } else {
        return self.cachedFiles.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        cell.detailTextLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    }
    
    NSInteger row = indexPath.row;
    
    NSDictionary* dict = [self.cachedFiles objectAtIndex:row];
    NSString* url = dict[CacheURLKey];
    cell.textLabel.text = [url lastPathComponent];
    cell.detailTextLabel.text = url;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = indexPath.row;
    
    NSDictionary* dict = [self.cachedFiles objectAtIndex:row];
    NSString* urlString = dict[CacheURLKey];
    urlString = [[KSYHTTPProxyService sharedInstance] getProxyUrl:urlString];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    [self presentViewController:[[KSYPlayerVC alloc] initWithURL:url] animated:YES completion:nil];
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
