//
//  zhnZhihuWedManager.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnZhihuWebManager.h"

static const NSString * baseUrl = @"http://news-at.zhihu.com/api/4/";

@implementation zhnZhihuWebManager
+ (zhnZhihuWebManager *)share{
    
    static dispatch_once_t once;
    static zhnZhihuWebManager * manager;
    dispatch_once(&once, ^{
        manager = [[zhnZhihuWebManager alloc]init];
    });
    return manager;
}


- (void)p_getStatusWithUrl:(NSString *)url parames:(NSDictionary *)dict success:(successBlock)success error:(errorBlock)zhnError{
  
    NSString * fullString = [NSString stringWithFormat:@"%@%@",baseUrl,url];
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", @"text/json", @"text/javascript", nil];
    [manager GET:fullString parameters:dict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (zhnError) {
            zhnError(error);
        }
        
    }];
}

@end
