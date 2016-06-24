//
//  webViewContainerController.h
//  RACzhihu
//
//  Created by zhn on 16/6/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>

@class mainModel;
@interface webViewContainerController : UIViewController

@property (nonatomic,strong) mainModel * statusModel;

@property (nonatomic,copy) NSArray * allContentStoriesArray;

@end
