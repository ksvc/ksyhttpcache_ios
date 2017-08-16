//
//  ShowFileDownloader.m
//  demo
//
//  Created by devcdl on 2017/8/10.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import "ShowFileDownloader.h"
#import <kSYHTTPCache/KSYFileDownloader.h>
#import <UIKit/UIKit.h>

@interface ShowFileDownloader ()
@property (nonatomic, strong) NSMutableArray<KSYFileDownloader*> *fileDownloaders;
@property (nonatomic, copy)   void(^progressBlock)(float);
@end

@implementation ShowFileDownloader

- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotify:) name:closePlayerNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleNotify:(NSNotification *)notification {
    [KSYFileDownloader handleClosePlayerForUrl:notification.userInfo[ClosePlayerURLKey] progressBlock:self.progressBlock];
}

- (NSMutableArray<KSYFileDownloader*>*)fileDownloaders {
    if (!_fileDownloaders) {
        _fileDownloaders = [NSMutableArray new];
    }
    return _fileDownloaders;
}

- (void)showDownloaderHandlerForUrl:(NSString *)url
                   onViewController:(id)viewController
                      progressBlock:(void(^)(float))progressBlock
                        playerBlock:(void(^)())playerBlock
{
    self.progressBlock = progressBlock;
    KSYFileDownloaderState state = [self downloaderStateForUrl:url];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (state == KSYFileDownloaderStateUnknown || state == KSYFileDownloaderStatePause || state == KSYFileDownloaderStateInvalid)
    {
        [alertController addAction:[UIAlertAction actionWithTitle:@"开始缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self downloadForUrl:url progressBlock:progressBlock];
        }]];
    }
    else if (state == KSYFileDownloaderStateDownloading) {
        [alertController addAction:[UIAlertAction actionWithTitle:@"暂停缓存" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self pauseForUrl:url];
        }]];
    }
    [alertController addAction:[UIAlertAction actionWithTitle:@"播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (playerBlock) {
            playerBlock();
            [KSYFileDownloader handleOpenPlayerForUrl:url progressBlock:self.progressBlock];
        }
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    if ([viewController isKindOfClass:[UIViewController class]]) {
        [viewController presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark --
#pragma mark -- private method

- (void)downloadForUrl:(NSString *)url progressBlock:(void(^)(float))progressBlock {
    __block NSInteger index = -1;
    [self.fileDownloaders enumerateObjectsUsingBlock:^(KSYFileDownloader * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString = [obj urlString];
        if ([url isEqualToString:urlString]) {
            index = idx;
            *stop = YES;
        }
    }];
    KSYFileDownloader *fileDownloader = nil;
    if (index > -1) {
        fileDownloader = self.fileDownloaders[index];
    } else {
        fileDownloader = [[KSYFileDownloader alloc] initWithUrlString:url progressBlock:progressBlock];
        [self.fileDownloaders addObject:fileDownloader];
    }
    [fileDownloader startDownload];
}

- (void)pauseForUrl:(NSString *)url {
    __block NSInteger index = -1;
    [self.fileDownloaders enumerateObjectsUsingBlock:^(KSYFileDownloader * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString = [obj urlString];
        if ([url isEqualToString:urlString]) {
            index = idx;
            *stop = YES;
        }
    }];
    if (index > -1) {
        KSYFileDownloader *fileDownloader = self.fileDownloaders[index];
        [fileDownloader pauseDownload];
    }
}

- (KSYFileDownloaderState)downloaderStateForUrl:(NSString *)url {
    __block KSYFileDownloaderState state = KSYFileDownloaderStateUnknown;
    [self.fileDownloaders enumerateObjectsUsingBlock:^(KSYFileDownloader * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *urlString = [obj urlString];
        if ([url isEqualToString:urlString]) {
            state = [obj downloaderState];
            *stop = YES;
        }
    }];
    return state;
}

@end
