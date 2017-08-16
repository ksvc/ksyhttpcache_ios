//
//  SamplesViewViewController.m
//  HTTPCacheDemo
//
//  Created by sujia on 2016/11/4.
//  Copyright © 2016年 kingsoft. All rights reserved.
//

#import "SamplesViewController.h"
#import <KSYHTTPCache/KSYHTTPProxyService.h>
#import "ShowFileDownloader.h"
#import "KSYHTTPCache/HTTPCacheDefines.h"
#import "KSYPlayerVC.h"

#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )

@interface SamplesViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *sampleList_withhttpcache;
@property(nonatomic,strong) NSArray *sampleList_withouthttpcache;
@property(nonatomic,strong) UINavigationBar *nav;

@property (nonatomic, strong) UILabel *progressLab;

@property (nonatomic, strong) ShowFileDownloader *downloaderManager;
@end

static NSString * const toBeDownloadUrlStr = @"https://mvvideo5.meitudata.com/571090934cea5517.mp4";

@implementation SamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setNavigationbar];
    [self initTableView];
}

-(NSMutableArray*)getNameAndProxyUrl:(NSString*)url {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:[url lastPathComponent]];
    //[array addObject: [[KSYHTTPProxyService sharedInstance] getProxyUrl:url]];
    [array addObject: [[KSYHTTPProxyService sharedInstance] getProxyUrl:url newCache:YES]];
    return array;
}

-(NSMutableArray*)getNameAndUrl:(NSString*)url {
    NSMutableArray* array = [[NSMutableArray alloc] init];
    [array addObject:[url lastPathComponent]];
    [array addObject:url];
    return array;
}

- (ShowFileDownloader *)downloaderManager {
    if (!_downloaderManager) {
        _downloaderManager = [[ShowFileDownloader alloc] init];
    }
    return _downloaderManager;
}

-(void)initTableView {
    NSMutableArray *sampleList = [[NSMutableArray alloc] init];
    [sampleList addObject:[self getNameAndProxyUrl:@"http://ks3-cn-beijing.ksyun.com/mobile/S09E20.mp4"]];
    
    [sampleList addObject:[self getNameAndProxyUrl:@"http://lavaweb-10015286.video.myqcloud.com/hong-song-mei-gui-mu-2.mp4"]];
    
    [sampleList addObject:[self getNameAndProxyUrl:@"https://mvvideo5.meitudata.com/571090934cea5517.mp4"]];
    [sampleList addObject:[self getNameAndProxyUrl:@"http://lavaweb-10015286.video.myqcloud.com/lava-guitar-creation-2.mp4"]];
    [sampleList addObject:[self getNameAndProxyUrl:@"http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4"]];
    [sampleList addObject:[self getNameAndProxyUrl:@"http://120.25.226.186:32812/resources/videos/minion_01.mp4"]];
    [sampleList addObject:[self getNameAndProxyUrl:@"http://120.25.226.186:32812/resources/videos/minion_04.mp4"]];
    self.sampleList_withhttpcache = sampleList;
    
    NSMutableArray *sampleList2 = [[NSMutableArray alloc] init];
    [sampleList2 addObject:[self getNameAndUrl:@"http://lavaweb-10015286.video.myqcloud.com/ideal-pick-2.mp4"]];
    [sampleList2 addObject:[self getNameAndUrl:@"http://static.smartisanos.cn/common/video/video-jgpro.mp4"]];
    
    self.sampleList_withouthttpcache = sampleList2;
    
    CGRect frame = CGRectMake(0, self.nav.frame.size.height, self.view.bounds.size.width, self.view.frame.size.height - self.nav.frame.size.height);
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.view addSubview:self.tableView];
}

- (void)setNavigationbar
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.nav = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, screenRect.size.width, 44)];
    
    //创建UINavigationItem
    UINavigationItem * navigationBarTitle = [[UINavigationItem alloc] initWithTitle:@"Sample URL List"];
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

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
        return 30.0f;
    else
        return 20.0f;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"使用KSYHTTPCache";
    } else {
        return @"不使用KSYHTTPCache";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (IOS_NEWER_OR_EQUAL_TO_7) {
        if (section == 0)
            return self.sampleList_withhttpcache.count;
        else
            return self.sampleList_withouthttpcache.count;
    } else {
        if (section == 0)
            return self.sampleList_withhttpcache.count - 1;
        else
            return self.sampleList_withouthttpcache.count - 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* simpleTableIdentifier = @"SimpleTableItem";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
        
        UILabel *progressLab = [[UILabel alloc] init];
        progressLab.tag = 100021;
        progressLab.backgroundColor = [UIColor brownColor];
        progressLab.frame = CGRectMake(self.view.bounds.size.width - 90, (cell.contentView.bounds.size.height - 30) / 2.0, 80, 30);
        [cell.contentView addSubview:progressLab];
    }
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    if (section == 0) {
        cell.textLabel.text = self.sampleList_withhttpcache[row][0];
    } else {
        cell.textLabel.text = self.sampleList_withouthttpcache[row][0];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger section = indexPath.section;
    NSInteger row = indexPath.row;
    
    NSArray *item = nil;
    if (section == 0) {
        item = self.sampleList_withhttpcache[row];
    } else {
        item = self.sampleList_withouthttpcache[row];
    }
    
    if (section == 0) {
        NSString *local = @"http://127.0.0.1:8123/";
        NSString *originalUrlStr = nil;
        NSString *httpServerUrlStr = [item[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (httpServerUrlStr.length > [local length]) {
            originalUrlStr = [httpServerUrlStr substringFromIndex:local.length];
        }
        if (![originalUrlStr hasPrefix:@"http://"] && ![originalUrlStr hasPrefix:@"https://"]) {
            return;
        }
        
        __weak typeof(self) weakSelf = self;
        [self.downloaderManager showDownloaderHandlerForUrl:originalUrlStr onViewController:self progressBlock:^(float progress) {
            UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            UILabel *progressLab = [cell.contentView viewWithTag:100021];
            if ((NSInteger)(progress * 10000) > 10000) {
                progress = 1.0;
            }
            progressLab.text = [NSString stringWithFormat:@"%f", progress];
        } playerBlock:^{
            __strong typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf presentViewController:[[KSYPlayerVC alloc] initWithURL:[NSURL URLWithString:httpServerUrlStr]] animated:YES completion:nil];
        }];
    } else {
        NSURL   *url  = [NSURL URLWithString:[item[1] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        [self presentViewController:[[KSYPlayerVC alloc] initWithURL:url] animated:YES completion:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
