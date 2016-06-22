//
//  zhnZhihuWebManager+mainVC.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnZhihuWebManager+mainVC.h"

@implementation zhnZhihuWebManager (mainVC)

- (void)getMainLatestStatusSuccess:(successBlock)success error:(errorBlock)z_error{
    
    NSString * url = @"news/latest";
    [self p_getStatusWithUrl:url parames:nil success:success error:z_error];
}


@end
