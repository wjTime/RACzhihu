//
//  webViewContainerController.m
//  RACzhihu
//
//  Created by zhn on 16/6/24.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "webViewContainerController.h"
#import "zhnHuWebViewController.h"
#import "mainModel.h"
@interface webViewContainerController ()

@property (nonatomic,assign) NSInteger currentIndex;

@property (nonatomic,strong) RACSubject * delegateSubJect;

@property (nonatomic,weak) zhnHuWebViewController * topVC;

@property (nonatomic,weak) zhnHuWebViewController * bottomVC;
@end

@implementation webViewContainerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    zhnHuWebViewController * childVC = [[zhnHuWebViewController alloc]init];
    childVC.statusModel = self.statusModel;
    [self addChildViewController:childVC];
    [self.view addSubview:childVC.view];
    childVC.view.frame = self.view.bounds;
    self.topVC = childVC;
    self.delegateSubJect = childVC.delegateSubject;
    
    [self initDelegateSubJectBlind];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (int index = 0; index < self.allContentStoriesArray.count; index++) {
            if ([self.statusModel.id isEqualToString:self.allContentStoriesArray[index]]) {
                self.currentIndex = (NSInteger)index;
            }
        }
    });
}

- (void)initDelegateSubJectBlind{
    @weakify(self)
    [self.delegateSubJect subscribeNext:^(id x) {
        @strongify(self)
        if ([x isEqualToString:KzhnSuccess]) {
            
            if (self.currentIndex - 1 >= 0) {
                
                mainModel * model = [[mainModel alloc]init];
                model.id = self.allContentStoriesArray[self.currentIndex - 1];
                zhnHuWebViewController * newVC = [[zhnHuWebViewController alloc]init];
                newVC.statusModel = model;
                [self addChildViewController:newVC];
                [self.view insertSubview:newVC.view belowSubview:self.topVC.view];
                newVC.view.frame = CGRectMake(0, -self.view.zhn_height, self.view.zhn_width, self.view.zhn_height);
                self.bottomVC = newVC;
                
                [UIView animateWithDuration:0.3 animations:^{
                    
                    newVC.view.frame = self.view.bounds;
                    self.topVC.view.frame = CGRectMake(0, self.view.zhn_height + 200, self.view.zhn_width, self.view.zhn_height);
                    
                    
                } completion:^(BOOL finished) {
                    [self.topVC.view removeFromSuperview];
                    self.currentIndex --;
                    self.topVC = self.bottomVC;
                    self.delegateSubJect = self.topVC.delegateSubject;
                    [self initDelegateSubJectBlind];
                }];
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
