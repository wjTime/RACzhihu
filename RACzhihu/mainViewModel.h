//
//  mainViewModel.h
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainViewModel : NSObject

@property (nonatomic,strong) RACCommand * todayStatusCommand;

@property (nonatomic,strong) RACCommand * dataSourceCommand;

@property (nonatomic,strong) RACSubject * hiddenNaviBottomSubject;

@property (nonatomic,strong) RACSubject * pushSubject;

@property (nonatomic,strong) RACSubject * bannerSubject;
@end


