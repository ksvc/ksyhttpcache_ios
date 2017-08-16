//
//  ShowFileDownloader.h
//  demo
//
//  Created by devcdl on 2017/8/10.
//  Copyright © 2017年 kingsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowFileDownloader : NSObject

- (void)showDownloaderHandlerForUrl:(NSString *)url
               onViewController:(id)viewController
                  progressBlock:(void(^)(float))progressBlock
                    playerBlock:(void(^)())playerBlock;

@end
