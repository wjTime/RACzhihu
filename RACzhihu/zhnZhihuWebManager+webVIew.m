//
//  zhnZhihuWebManager+webVIew.m
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnZhihuWebManager+webVIew.h"

@implementation zhnZhihuWebManager (webVIew)
- (void)getWebViewContentStatusWithId:(NSString *)idStr success:(successBlock)success error:(errorBlock)z_error{
    
    NSString * url = [NSString stringWithFormat:@"news/%@",idStr];
    [self p_getStatusWithUrl:url parames:nil success:success error:z_error];
    
}
@end
