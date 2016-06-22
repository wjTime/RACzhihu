//
//  mainViewController.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "mainViewController.h"
#import "launchViewController.h"
#import "mainViewModel.h"
#import "mainModel.h"
#import "SDCycleScrollView.h"

static CGFloat KbannerViewHeight = 250;
@interface mainViewController ()<UITableViewDelegate>

@property (nonatomic,strong) mainViewModel * viewModel;
@property (nonatomic,weak) SDCycleScrollView * bannerView;
@property (nonatomic,weak) UIView * naviBar;
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView * mainTableView = [[UITableView alloc]init];
    [self.view addSubview:mainTableView];
    mainTableView.frame = self.view.bounds;
    mainTableView.delegate = self;
    mainTableView.contentInset = UIEdgeInsetsMake(KbannerViewHeight, 0, 0, 0);
    RACSignal * datasourceSignal = [self.viewModel.dataSourceCommand execute:mainTableView];
    [datasourceSignal subscribeNext:^(id x) {
        
        CGFloat delta = KbannerViewHeight + mainTableView.contentOffset.y ;
        CGFloat scale = delta / (KbannerViewHeight - 64);
        self.naviBar.alpha = scale;
        if (KbannerViewHeight - delta >= 0) {
            [self.bannerView zhn_setHeight:KbannerViewHeight - delta];
        }
    }];
    
    // 轮播咯
    SDCycleScrollView * bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KbannerViewHeight)];
    bannerView.autoScrollTimeInterval = 100;
    bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    bannerView.titleLabelHeight = 100;
    bannerView.titleLabelTextFont = [UIFont systemFontOfSize:20];
    bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    [self.view addSubview:bannerView];
    self.bannerView = bannerView;
    
    // 数据的处理
    [self.viewModel.todayStatusCommand execute:bannerView];

    // naviBar
    self.navigationController.navigationBar.hidden = YES;
    UIView * zhnNaviBar = [[UIView alloc]init];
    zhnNaviBar.alpha = 0;
    [self.view addSubview:zhnNaviBar];
    zhnNaviBar.backgroundColor = zhnColor(0, 137, 211, 1);
    zhnNaviBar.frame = CGRectMake(0, 0, KscreenWidth, 64);
    self.naviBar = zhnNaviBar;
    
    
    launchViewController * launchVC = [[launchViewController alloc]init];
    [launchVC didMoveToParentViewController:self];
    [self.view addSubview:launchVC.view];
    [launchVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
}


- (mainViewModel *)viewModel{
    
    if (_viewModel == nil) {
        _viewModel = [[mainViewModel alloc]init];
    }
    return _viewModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
