//
//  zhnZhihuWebManager+webVIew.h
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnZhihuWebManager.h"

@interface zhnZhihuWebManager (webVIew)

- (void)getWebViewContentStatusWithId:(NSString *)idStr success:(successBlock)success error:(errorBlock)z_error;

@end
