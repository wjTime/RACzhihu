//
//  zhnZhihuWebManager+launch.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnZhihuWebManager+launch.h"

@implementation zhnZhihuWebManager (launch)

- (void)getLaunchImageWithSuccess:(successBlock)success error:(errorBlock)z_error{
    
    NSString * url = @"start-image/1080*1776";
    [self p_getStatusWithUrl:url parames:nil success:success error:z_error];
}

@end
