//
//  SamplesViewViewController.m
//  HTTPCacheDemo
//
//  Created by sujia on 2016/11/4.
//  Copyright © 2016年 kingsoft. All rights reserved.
//

#import "SamplesViewController.h"
#import <KSYHTTPCache/KSYHTTPProxyService.h>
#import "KSYPlayerVC.h"

#define IOS_NEWER_OR_EQUAL_TO_7 ( [ [ [ UIDevice currentDevice ] systemVersion ] floatValue ] >= 7.0 )

@interface SamplesViewController () <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *sampleList_withhttpcache;
@property(nonatomic,strong) NSArray *sampleList_withouthttpcache;
@property(nonatomic,strong) UINavigationBar *nav;

@end

@implementation SamplesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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


-(void)initTableView {
    NSMutableArray *sampleList = [[NSMutableArray alloc] init];
    [sampleList addObject:[self getNameAndUrl:@"http://ks3-cn-beijing.ksyun.com/mobile/S09E20.mp4"]];
    [sampleList addObject:[self getNameAndUrl:@"http://kss.ksyun.com/eflakee/FLV/15702274_1474868965.flv"]];
    [sampleList addObject:[self getNameAndUrl:@"http://mpvideo-test.b0.upaiyun.com/5813998fb092e5771.mp4"]];
    [sampleList addObject:[self getNameAndUrl:@"https://mvvideo5.meitudata.com/571090934cea5517.mp4"]];
    [sampleList addObject:[self getNameAndUrl:@"http://test.live.ksyun.com/live/76C1.flv"]];
    [sampleList addObject:[self getNameAndUrl:@"http://zbvideo.ks3-cn-beijing.ksyun.com/record/live/101743_1466076252/hls/101743_1466076252.m3u8"]];
    [sampleList addObject:[self getNameAndUrl:@"http://101.96.8.164/1252759537.vod2.myqcloud.com/fe84f2a6vodsgp1252759537/7a1649e89031868222946874301/f0.mp4"]];
    [sampleList addObject:[self getNameAndUrl:@"http://test.live.ks-cdn.com/live/sunyazhou.flv"]];
    self.sampleList_withhttpcache = sampleList;
    
    NSMutableArray *sampleList2 = [[NSMutableArray alloc] init];
    [sampleList2 addObject:[self getNameAndUrl:@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"]];
    [sampleList2 addObject:[self getNameAndUrl:@"http://zbvideo.ks3-cn-beijing.ksyun.com/record/live/101743_1466076252/hls/101743_1466076252.m3u8"]];
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
    
    UITableViewCell *cell  = [tableView cellForRowAtIndexPath:indexPath];
    cell.userInteractionEnabled = NO;
    //NSString *strUrl = [[KSYHTTPProxyService sharedInstance] getProxyUrl:item[1] newCache:YES];
    //NSURL   *url  = [NSURL URLWithString:strUrl];
    //[self presentViewController:[[KSYPlayerVC alloc] initWithURL:url] animated:YES completion:nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSString *strUrl = [[KSYHTTPProxyService sharedInstance] getProxyUrl:item[1] newCache:YES];
        NSURL   *url  = [NSURL URLWithString:strUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:[[KSYPlayerVC alloc] initWithURL:url] animated:YES
                             completion:^(void){
                                 cell.userInteractionEnabled = YES;
            }];
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
