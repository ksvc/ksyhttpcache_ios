//
//  HTTPCacheDefines.h
//  KSYHTTPCache
//
//  Created by sujia on 2016/10/31.
//  Copyright © 2016年 kingsoft. All rights reserved.
//

#ifndef HTTPCacheDefines_h
#define HTTPCacheDefines_h

extern NSString *CacheStatusNotification;
extern NSString *CacheErrorNotification;

extern NSString *CacheURLKey;
extern NSString *CacheFragmentsKey;
extern NSString *CacheContentLengthKey;
extern NSString *CacheFilePathKey;

extern NSString *CacheErrorCodeKey;

extern NSString *CacheSDKVersion; //当前KSYHTTPCacheSDK版本号

/**
 * 错误码
 */
typedef NS_ENUM(NSInteger, KSYHTTPCacheErrorCode) {
    OK                    = 0,
    UnknownError          = 1,
    
    //cache
    OpenCacheError        = 1001,
    ReadCacheError        = 1002,
    WriteCacheError       = 1003,
    CloseCacheError       = 1004,
    DeleteCacheError      = 1005,
    SaveConfigError       = 1006,
    
    //source
    HeadRequestError      = 2001,
    HTTPDownloadError     = 2002,
    
    //server
    StartServerError      = 3001, // failed to start local http server
    InvalidRequestError   = 3002, //malformed HTTP request
    UnknowHTTPMethodError = 3003, //a HTTP request with a method other than GET or HEAD
};

typedef NS_ENUM(NSInteger, KSYCacheStrategy) {
    MaxCacheSizeLimited    = 0,
    MaxFilesCountLimited    = 1,
};

#endif /* HTTPCacheDefines_h */
