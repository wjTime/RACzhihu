//
//  zhnZhihuWedManager.h
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^successBlock)(id success);
typedef void(^errorBlock)(id error);


@interface zhnZhihuWebManager : NSObject


+ (zhnZhihuWebManager *)share;

- (void)p_getStatusWithUrl:(NSString *)url parames:(NSDictionary *)dict success:(successBlock)success error:(errorBlock)zhnError;


@end
