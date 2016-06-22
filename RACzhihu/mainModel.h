//
//  mainModel.h
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface mainModel : NSObject

@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) NSArray * images;

@property (nonatomic,copy) NSString * image;

@property (nonatomic,copy) NSString * id;

@property (nonatomic,copy) NSString * ga_prefix;

@property (nonatomic,copy) NSString * title;

@end
