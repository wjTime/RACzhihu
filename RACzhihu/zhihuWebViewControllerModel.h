//
//  zhihuWebViewControllerModel.h
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zhihuWebViewControllerModel : NSObject

@property (nonatomic,strong) RACCommand * statusCommand;

@property (nonatomic,strong) RACCommand * scrollCommand;
@end
