//
//  ViewController.m
//
//  Created by yiqian on 11/3/15.
//  Copyright (c) 2015 kingsoft. All rights reserved.
//

#import "ViewController.h"
#import "KSYPlayerVC.h"
#import "CacheSettingsViewController.h"
#import "SamplesViewController.h"
#import "CachedFileListViewController.h"
#import "CachingFileListViewController.h"
#import "KSYHTTPCache/KSYHTTPProxyService.h"

@interface ViewController ()

@property KSYPlayerVC * playerVC;
@property NSURL * url;
@end

@implementation ViewController{
    UIButton *btnShowCacheSettingView;
    UIButton *btnShowSamplesView;
    UIButton *btnClearCache;
    UIButton *btnShowCachedFileList;
    UIButton *btnShowCachingFileList;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initUI];
}

- (BOOL)shouldAutorotate {
    [self layoutUI];
    return YES;
}

- (void)initUI{
    btnShowCacheSettingView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShowCacheSettingView setTitle:@"缓存策略设置" forState:UIControlStateNormal];
    btnShowCacheSettingView.backgroundColor = [UIColor lightGrayColor];
    [btnShowCacheSettingView addTarget:self action:@selector(onShowCacheSettingView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowCacheSettingView];
    
    btnClearCache = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnClearCache setTitle:@"清空缓存区" forState:UIControlStateNormal];
    btnClearCache.backgroundColor = [UIColor lightGrayColor];
    [btnClearCache addTarget:self action:@selector(onClearCache) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnClearCache];
    
    btnShowSamplesView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShowSamplesView setTitle:@"测试URL列表" forState:UIControlStateNormal];
    btnShowSamplesView.backgroundColor = [UIColor lightGrayColor];
    [btnShowSamplesView addTarget:self action:@selector(onShowSamplesView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowSamplesView];
    
    btnShowCachedFileList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShowCachedFileList setTitle:@"缓存已完成文件列表" forState:UIControlStateNormal];
    btnShowCachedFileList.backgroundColor = [UIColor lightGrayColor];
    [btnShowCachedFileList addTarget:self action:@selector(onShowCachedFiles) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowCachedFileList];
    
    btnShowCachingFileList = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btnShowCachingFileList setTitle:@"缓存未完成文件列表" forState:UIControlStateNormal];
    btnShowCachingFileList.backgroundColor = [UIColor lightGrayColor];
    [btnShowCachingFileList addTarget:self action:@selector(onShowCachingFiles) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnShowCachingFileList];
    
    _url = [NSURL URLWithString:@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"];
    _playerVC   = [[KSYPlayerVC alloc] initWithURL:_url];
    
    [self layoutUI];
}

-(void)onShowCacheSettingView {
    [self presentViewController:[[CacheSettingsViewController alloc] init] animated:true completion:nil];
}

- (void)onClearCache {
    NSError *error;
    [[KSYHTTPProxyService sharedInstance] deleteAllCachesWithError:&error];
    if (error) {
        NSLog(@"clear cache failure with error: %@", error);
    }
}

-(void)onShowCachedFiles {
    NSArray* cachedFiles = [[KSYHTTPProxyService sharedInstance] getAllCachedFileListWithError:nil];
    //NSLog(@"cached files: %@", cachedFiles);
    
   [self presentViewController:[[CachedFileListViewController alloc] init] animated:true completion:nil];
}

-(void)onShowCachingFiles {
    NSArray* cachingFiles = [[KSYHTTPProxyService sharedInstance] getAllCachingFileListWithError:nil];
    //NSLog(@"caching files: %@", cachingFiles);
    
    [self presentViewController:[[CachingFileListViewController alloc] init] animated:true completion:nil];
}

-(void)onShowSamplesView:(id)sender {
    [self presentViewController:[[SamplesViewController alloc] init] animated:true completion:nil];
}

- (void) layoutUI {
    CGFloat wdt = self.view.bounds.size.width;
    CGFloat hgt = self.view.bounds.size.height;
    
    CGFloat btnWdt = wdt * 0.6;
    CGFloat btnHgt = 40;
    
    CGFloat xPos = (wdt - btnWdt) / 2;
    CGFloat yPos = (hgt - btnHgt*5) / 2 - btnHgt*3;
    btnShowCacheSettingView.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos = (hgt - btnHgt*5) / 2 - btnHgt;
    btnClearCache.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos = (hgt - btnHgt*5) / 2  + btnHgt;
    btnShowSamplesView.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos = (hgt - btnHgt*5) / 2  + btnHgt * 3;
    btnShowCachedFileList.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
    
    yPos = (hgt - btnHgt*5) /2 + btnHgt * 5;
    btnShowCachingFileList.frame = CGRectMake( xPos, yPos, btnWdt, btnHgt);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
