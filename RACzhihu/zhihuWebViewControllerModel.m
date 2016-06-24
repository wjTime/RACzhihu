//
//  zhihuWebViewControllerModel.m
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhihuWebViewControllerModel.h"
#import "zhnZhihuWebManager+webVIew.h"
#import "zhihuWebViewModel.h"
#import "mainModel.h"

@interface zhihuWebViewControllerModel()<UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView * webHeadView;

@property (nonatomic,strong) UIImageView * arrowImageView;

@property (nonatomic,strong) UIView * previousStoryView;

@property (nonatomic,strong) UIView * subView;

@property (nonatomic,strong) RACSubject * delegateSubject;
@end



@implementation zhihuWebViewControllerModel


- (instancetype)init{
    
    if (self = [super init]) {
        [self initialiBlind];
    }
    return self;
}

- (void)initialiBlind{
    
    // webview 数据处理
    _statusCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSArray * input) {
        
        mainModel * statusModel = [input firstObject];
        UIWebView * contentWebView = [input lastObject];
        contentWebView.scrollView.delegate = self;
        
        RACSignal * statusSinal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [[zhnZhihuWebManager share]getWebViewContentStatusWithId:statusModel.id success:^(id success) {
                zhihuWebViewModel * model = [zhihuWebViewModel yy_modelWithJSON:success];
                
                [subscriber sendNext:model];
                [subscriber sendCompleted];
            } error:^(id error) {
                [subscriber sendNext:KzhnError];
                [subscriber sendCompleted];
            }];
            return nil;
        }];
        
        return statusSinal;
    }];
    
    
    // 滑动的处理
    _scrollCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(NSArray * viewArray) {
       
        _webHeadView = viewArray[0];
        _previousStoryView = viewArray[1];
        _arrowImageView = viewArray[2];
        _subView = viewArray[3];
        _delegateSubject = viewArray[4];
        
        return [RACSignal empty];
    }];
}


#pragma mark 
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = scrollView.contentOffset.y + 20;
    if (200 - delta < 0) {
        delta = 200;
    }
    
    if (delta < -100) {
        _arrowImageView.transform = CGAffineTransformMakeRotation(M_PI);
    }else if(delta > -100){
        _arrowImageView.transform = CGAffineTransformIdentity;
    }
    
    [_previousStoryView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_subView.mas_top).with.offset(- 60 - delta);
    }];
    [_webHeadView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(200 - delta);
    }];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{

    CGFloat delta = scrollView.contentOffset.y + 20;
    if (delta < -100) {
        [_delegateSubject sendNext:KzhnSuccess];
    }
}

@end

