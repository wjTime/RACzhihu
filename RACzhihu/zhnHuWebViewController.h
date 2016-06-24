//
//  zhnHuWebViewController.h
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import <UIKit/UIKit.h>
@class mainModel;
@interface zhnHuWebViewController : UIViewController

@property (nonatomic,strong) mainModel * statusModel;

@property (nonatomic,strong) RACSubject * delegateSubject;

@end
