//
//  zhnHuWebViewController.m
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "zhnHuWebViewController.h"
#import "zhihuWebViewControllerModel.h"
#import "zhihuWebViewModel.h"

@interface zhnHuWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) zhihuWebViewControllerModel  * viewModel;

@property (nonatomic,strong) zhihuWebViewModel * model;

@end

@implementation zhnHuWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIWebView * contentWebView = [[UIWebView alloc]init];
    contentWebView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentWebView];
    contentWebView.delegate = self;
    [contentWebView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(-20, 0, 0, 0));
    }];
    
    // 头部位置
    UIImageView * headImageView = [[UIImageView alloc]init];
    headImageView.contentMode = UIViewContentModeScaleAspectFill;
    headImageView.clipsToBounds = YES;
    [self.view addSubview:headImageView];
    [headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.height.mas_equalTo(@200);
    }];

    UILabel * headTitileLabel = [[UILabel alloc]init];
    headTitileLabel.numberOfLines = 0;
    headTitileLabel.textColor = [UIColor whiteColor];
    headTitileLabel.font = [UIFont systemFontOfSize:22];
    [headImageView addSubview:headTitileLabel];
    [headTitileLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headImageView.mas_left).with.offset(15);
        make.right.equalTo(headImageView.mas_right).with.offset(-15);
        make.bottom.equalTo(headImageView.mas_bottom).with.offset(-20);
        make.height.mas_equalTo(@60);
    }];
    
    UILabel * editLabel = [[UILabel alloc]init];
    editLabel.textAlignment = NSTextAlignmentRight;
    editLabel.font = [UIFont systemFontOfSize:10];
    [headImageView addSubview:editLabel];
    editLabel.textColor = [UIColor blackColor];
    [editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(headImageView.mas_right).with.offset(-30);
        make.bottom.equalTo(headImageView.mas_bottom).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(200, 20));
    }];
    
    UIView * previousStoryView = [[UIView alloc]init];
    [self.view addSubview:previousStoryView];
    [previousStoryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_top).with.offset( - 60);
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    UIImageView * arrowImageView = [[UIImageView alloc]init];
    [previousStoryView addSubview:arrowImageView];
    arrowImageView.image = [UIImage imageNamed:@"arrow"];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(previousStoryView.mas_centerX).with.offset(-10);
        make.centerY.equalTo(previousStoryView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    UILabel * lastLabel = [[UILabel alloc]init];
    lastLabel.text = @"上一篇";
    lastLabel.textColor = [UIColor grayColor];
    lastLabel.textAlignment = NSTextAlignmentLeft;
    [previousStoryView addSubview:lastLabel];
    [lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(previousStoryView.mas_centerX);
        make.centerY.equalTo(previousStoryView.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    // 加载数据
    RACSignal * modelSignal = [self.viewModel.statusCommand execute:@[self.statusModel,contentWebView]];
    [modelSignal subscribeNext:^(zhihuWebViewModel * model) {
        
        headTitileLabel.text = model.title;
        
        [headImageView sd_setImageWithURL:[NSURL URLWithString:model.image]];
        
        editLabel.text = model.image_source;
        
        NSString * htmlStr = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",model.css[0],model.body];
        dispatch_async(dispatch_get_main_queue(), ^{
            [contentWebView loadHTMLString:htmlStr baseURL:nil];
        });
        
    }];
    
    [self.viewModel.scrollCommand execute:@[headImageView,previousStoryView,arrowImageView,self.view,self.delegateSubject]];
}

- (zhihuWebViewControllerModel *)viewModel{
    if (_viewModel == nil) {
        _viewModel = [[zhihuWebViewControllerModel alloc]init];
    }
    return _viewModel;
}

- (RACSubject *)delegateSubject{
    if (_delegateSubject == nil) {
        _delegateSubject = [RACSubject subject];
    }
    return _delegateSubject;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
