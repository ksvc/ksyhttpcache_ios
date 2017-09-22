# 金山云iOS HTTPCache SDK
金山云iOS平台http缓存SDK，可方便地与播放器集成，实现http视频边播放边下载（缓存）功能。ksyun http cache sdk for ios platform, it's easy to integrated with media players to provide caching capability when watching http videos.

## 1. 产品概述
金山云iOS HTTPCache SDK可以方便地和播放器进行集成，提供对HTTP视频边播放缓存的功能，缓存完成的内容可以离线工作。

KSY HTTPCache与播放器及视频服务器的关系如下图：
![](https://github.com/sujia/image_foder/blob/master/ksy_http_cache.png)

KSY HTTPCache相当于本地的代理服务，使用KSY HTTPCache后，播放器不直接请求视频服务器，而是向KSY HTTPCache请求数据。KSY HTTPCache在代理HTTP请求的同时，缓存视频数据到本地。

## 2.功能说明
它可以很方便的和播放器进行集成，提供以下功能：
1. http点播视频边缓存边播放，且播放器可从通过回调得到缓存的进度以及错误码

2. 缓存完成的视频，再次点播时可以离线播放，不再请求视频    
获取代理url方式（newCache参数一定要置为NO）：[[KSYHTTPProxyService sharedInstance] getProxyUrl:@"url.mp4" newCache:NO]];

3. 查询缓存已完成的文件列表， 缓存未完成的文件列表

4. 清除缓存（清除所有缓存，或删除某个url缓存）
      
5. 提供两种缓存策略供选择（限制缓存区总大小或者限制缓存文件总个数)

6. 提供预缓存接口KSYFileDownloader （v1.2.1）


## 3.下载和使用
下载framework目录下的KSYHTTPCache.framework，并添加到工程中，然后添加CocoaAsyncSocket，CocoaLumberjack，KSYMediaPlayer_iOS.framework依赖库到工程；

若使用cocoaPods，需要在pods文件中引入
    pod 'KSYHTTPCache'
    pod 'KSYMediaPlayer_iOS'
    执行pod install命令即可

若要使用【预缓存】功能，需要引入KSYFileDownloader，即#import <KSYHTTPCache/KSYFileDownloader.h>，可参考demo工程下的ShowFileDownloader类

为了保证正常工作，推荐在AppDelegate中开启和关闭服务，如下:
```objectivec
#import <KSYHTTPCache/KSYHTTPProxyService.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[KSYHTTPProxyService sharedInstance] startServer];
    return YES;
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[KSYHTTPProxyService sharedInstance] stopServer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[KSYHTTPProxyService sharedInstance] startServer];
}

```

proxy与播放器的集成如下所示，通过getProxyUrl接口获得代理播放地址，进行播放。

```objectivec
//get proxy url from ksyhttpcache
NSString *proxyUrl = [[KSYHTTPProxyService sharedInstance] getProxyUrl:@"http://maichang.kssws.ks-cdn.com/upload20150716161913.mp4"];
    
//init player with proxy url
KSYMoviePlayerController *player = [[KSYMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:proxyUrl]];

//play the video
[player prepareToPlay];
```

使用以上方法，proxy将采用默认配置。可采用如下方法自定义配置(需在startServer前设置)：

-  设置缓存区位置
   ```objectivec
  (void)setCacheRoot:(NSString *)cacheRoot
   ```

-  缓存区大小限制策略（文件个数限制、文件总大小限制)，目前这两种策略只能二选一，且策略在每次播放完成或者退出播放时生效。
   
   - 使用限制文件总大小的策略，默认使用的是该策略，且缓存大小为500M

   ```objectivec
  -(void)setMaxCacheSizeLimited:(long long)maxCacheSize;
   ```
   
   - 使用限制文件总个数的策略

   ```objectivec
   -(void)setMaxFilesCountLimited:(NSInteger)maxFilesCount;
   ```

-  状态监听
   
   - KSYHTTPCache发生错误时的发送CacheErrorNotification通知

   ```objectivec
   CacheErrorNotification
   ```
   
   - KSYHTTPCache缓存进度发送变化时发送CacheStatusNotification通知

   ```objectivec
   CacheStatusNotification
  ```
   
   注册notification监听
   ```objectivec
   [[NSNotificationCenter defaultCenter] addObserver:self 
               selector:@selector(mediaCacheDidChanged:)
               name:CacheStatusNotification 
               object:nil];
   ```
   去掉notification监听
   ```objectivec
   [[NSNotificationCenter defaultCenter] removeObserver:self
                name:CacheStatusNotification
                object:nil];
    ```


## 4.其他接口说明


对于http flv直播，如果播放器通过接口getProxyUrl( ur）获得播放地址，播放行为是：首次播放，边播放边缓存；以后播放相同url，则是回看缓存好的视频。
而如果播放器通过getProxyUrl(url, newCache)获得播放地址，播放行为是：newCache参数为true，无论是否有url对应的缓存内容，都是播放并缓存新的直播内容。newCache为false，如果有url对应的缓存内容（命中缓存），播放时回看已缓存的直播内容；没有命中的缓存视频（未命中缓存），则播放并缓存新的直播内容。

```objectivec
(NSString*)getProxyUrl:(NSString*)url newCache:(BOOL)newCache;
```
```objectivec
(NSString*)getProxyUrl:(NSString*)url;
```
启动server
```objectivec
(void)startServer;
```
关闭server
```objectivec
(void)stopServer;
```
查询server是否在运行状态
```objectivec
(BOOL)isRunning;
```
删除缓存区所以文件
```objectivec
(void)deleteAllCachesWithError:(NSError**)error;
```
删除某个url对应的缓存文件
```objectivec
(void)deleteCacheForUrl:(NSURL*)url error:(NSError**)error;
```
 查询某个url缓存是否完成
```objectivec
-(BOOL)isCacheCompleteForUrl:(NSURL*)url;
```
获得缓存已完成文件列表
```objectivec
-(NSArray*)getAllCachedFileListWithError:(NSError**)errors;
```
获得缓存未完成文件列表
```objectivec
-(NSArray*)getAllCachingFileListWithError:(NSError**)error;
```
获得url对应缓存文件的路径
```objectivec
-(NSString*)getCachedFilePathForUrl:(NSURL *)url;
```
获得url对应缓存未完成url对应的cache fragment
```objectivec
-(NSArray*)getCacheFragmentForUrl:(NSURL *)url error:(NSError **)error;
```
查询缓存区位置
```objectivec
-(NSString*)cacheRoot;
```

获得缓存区路径

## 5.其他文档
请见[wiki](https://github.com/ksvc/ksyhttpcache_ios/wiki)

## 6.反馈与建议
- 主页：[金山云](http://www.ksyun.com/)
- 邮箱：<zengfanping@kingsoft.com>
- QQ讨论群：574179720
- Issues:https://github.com/ksvc/ksyhttpcache_ios/issues
