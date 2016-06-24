//
//  launchViewModel.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "launchViewModel.h"
#import "launchModel.h"
#import "zhnZhihuWebManager+launch.h"

@implementation launchViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initialBind];
    }
    return self;
}

- (void)initialBind{
    
    _launchCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        UIImageView * showImageView = input[0];
        UILabel * authorLabel = input[1];
        UIViewController * launchVC = input[2];
        
        RACSignal * launchSingle = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [[zhnZhihuWebManager share]getLaunchImageWithSuccess:^(id success) {
                
                launchModel * model = [launchModel yy_modelWithJSON:success];
                
                authorLabel.text = model.text;
                [showImageView sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                    [UIView animateWithDuration:2.3 delay:0.2 options:UIViewAnimationOptionCurveLinear animations:^{
                        showImageView.alpha = 0;
                        showImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
                    } completion:^(BOOL finished) {
                        [UIView animateWithDuration:0.5 animations:^{
                            
                            launchVC.view.alpha = 0;
                            
                        } completion:^(BOOL finished) {
                            
                            [launchVC.view removeFromSuperview];
                            [launchVC removeFromParentViewController];
                        }];
                    }];
                }];
                
                [subscriber sendNext:model];
                [subscriber sendCompleted];
                
            } error:^(id error) {
                
            }];
            return  nil;
        }];
        return launchSingle;
    }];
    
}




@end
