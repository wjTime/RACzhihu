//
//  zhihuWebViewModel.h
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface zhihuWebViewModel : NSObject

@property (nonatomic,copy) NSString * body;

@property (nonatomic,copy) NSString * ga_prefix;

@property (nonatomic,copy) NSString * id;

@property (nonatomic,copy) NSString * image;

@property (nonatomic,copy) NSString * image_source;

@property (nonatomic,copy) NSString * js;

@property (nonatomic,copy) NSString * title;

@property (nonatomic,copy) NSString * type;

@property (nonatomic,strong) NSArray * css;

@property (nonatomic,strong) NSArray * images;


@end
