//
//  HGTools.m
//  EasyReading
//
//  Created by koreadragon on 16/5/31.
//  Copyright © 2016年 koreadragon. All rights reserved.
//

#import "HGTools.h"
#import "sys/utsname.h"
#include <sys/types.h>
#include <sys/sysctl.h>




@interface HGTools()
@end

@implementation HGTools
#define serverUrl @"http://192.168.1.1:8080/jiekou"

#define TIMEOUT_TIME 10.0f


//#define serverUrl @"http://www.baidu.com"
+ (BOOL)connectedToNetwork
{
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        printf("Error. Could not recover network reachability flags\n");
        return NO;
    }
    
    BOOL isReachable = ((flags & kSCNetworkFlagsReachable) != 0);
    BOOL needsConnection = ((flags & kSCNetworkFlagsConnectionRequired) != 0);
    return (isReachable && !needsConnection) ? YES : NO;
}

+(void)POST:(NSString *)URL params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))Error{
   

    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求格式
    
    
//    [manager.requestSerializer setHTTPShouldHandleCookies:NO];

    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
//    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application.json",@"text/html",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain",@"application/json", nil]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TIMEOUT_TIME;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *postString = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        postString = [NSString stringWithFormat:@"%@%@",serverUrl,URL];
    }
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    //发送post请求
    
    postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager POST:postString parameters:dict success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //请求成功
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        Error(task,error);
        
    }];
    
    
    
}

+(void)POSTWithProgressURL:(NSString *)URL params:(NSDictionary *)params progress:(void(^)(NSProgress *)) progress success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask * Task, NSError * error))Error {
    
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求格式
     manager.responseSerializer = [AFJSONResponseSerializer serializer];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application.json",@"text/html",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain",@"application/json", nil]];
    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TIMEOUT_TIME;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    NSString *postString = URL;
    
    if (![URL hasPrefix:@"http"]) {
        
        postString = [NSString stringWithFormat:@"%@%@",serverUrl,URL];
    }
    
    NSMutableDictionary *dict = [params mutableCopy];
    
    //发送post请求
    
    postString = [postString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:postString parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        NSDictionary *responseDict = (NSDictionary *)responseObject;
        
        success(responseDict);
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         Error(task,error);
        
    }];
    
    

    
}


+(void)GET:(NSString *)URL success:(void (^)(id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))Error{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];

    
    [manager.requestSerializer setHTTPShouldHandleCookies:NO];

    // 设置超时时间
    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    manager.requestSerializer.timeoutInterval = TIMEOUT_TIME;
    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application.json",@"text/html",@"text/json",@"text/javascript",@"application/x-javascript",@"text/plain",@"application/json", nil]];
    NSString *getString = URL;
    if (![URL hasPrefix:@"http"]) {
        getString = [NSString stringWithFormat:@"%@%@",serverUrl,URL];
    }
    
    getString = [getString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"HGTools GET 地址--%@",getString);

    //发送get请求

        [manager GET:getString parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            success(responseObject);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

            Error(task,error);
            
        }];
    
    
    
}


+(BOOL)isRealNull:(id)obj{
    
    
    //（null）处理时需要用 obj == nil
    return (([obj isEqual: [NSNull null]] || [obj isEqual:@""] || [obj isEqual:@"null"]|| [obj isEqual:@"(null)"] || [obj isEqual:@"<null>"]|| [obj isEqual:nil] || [obj isKindOfClass:[NSNull class]] || [obj isEqual: NULL] || (obj == nil))) ;
}

+(id )returnStr:(NSString *)string
ifObjIsRealNull:(id)obj
{
    
    if ([self isRealNull:obj]) {
        return string;
    } else{
        return obj;
    };
    
}

 @end
