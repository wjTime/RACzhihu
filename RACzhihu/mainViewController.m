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
@property (nonatomic,weak) UIView * naviBarBottom;
@property (nonatomic,weak) UILabel * todayShowLabel;
@end

@implementation mainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UITableView * mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, KscreenWidth, KscreenHeight) style:UITableViewStylePlain];
    mainTableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:mainTableView];
    mainTableView.delegate = self;
    UIView * tempBackHeadView = [[UIView alloc]init];
    tempBackHeadView.frame = CGRectMake(0, 0, KscreenWidth, KbannerViewHeight);
    mainTableView.tableHeaderView  = tempBackHeadView;
    RACSignal * datasourceSignal = [self.viewModel.dataSourceCommand execute:mainTableView];
    [datasourceSignal subscribeNext:^(id x) {
        
        CGFloat delta = mainTableView.contentOffset.y ;
        CGFloat scale = delta / (KbannerViewHeight - 64);
        self.naviBar.alpha = scale;
        self.naviBarBottom.alpha = scale;
        if (KbannerViewHeight - delta >= 0) {
             [self.bannerView zhn_setHeight:KbannerViewHeight - delta];
        }else{
            // 不加这种情况下的判断快速滑动的时候会有问题的
             [self.bannerView zhn_setHeight:0];
        }
    }];
    
    // 轮播咯
    SDCycleScrollView * bannerView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, KbannerViewHeight)];
    bannerView.autoScrollTimeInterval = 100;
    bannerView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
    bannerView.titleLabelHeight = 100;
    bannerView.titleLabelTextFont = [UIFont systemFontOfSize:20];
    bannerView.titleLabelBackgroundColor = [UIColor clearColor];
    self.bannerView = bannerView;
    [self.view addSubview:bannerView];
    
    // 数据的处理
    RACSignal * statusSignal =  [self.viewModel.todayStatusCommand execute:bannerView];
    [statusSignal subscribeNext:^(id x) {
        if ([x isEqualToString:KzhnSuccess]) {
            [mainTableView reloadData];
        }
    }];

    // naviBar
    self.navigationController.navigationBar.hidden = YES;
    UIView * zhnNaviBar = [[UIView alloc]init];
    zhnNaviBar.alpha = 0;
    [self.view addSubview:zhnNaviBar];
    zhnNaviBar.backgroundColor = zhnColor(0, 137, 211, 1);
    zhnNaviBar.frame = CGRectMake(0, 0, KscreenWidth, 20);
    self.naviBar = zhnNaviBar;
    
    // navibarBottom
    UIView * naviBarBottomView = [[UIView alloc]init];
    [self.view addSubview:naviBarBottomView];
    self.naviBarBottom = naviBarBottomView;
    naviBarBottomView.backgroundColor = zhnColor(0, 137, 211, 1);
    naviBarBottomView.frame = CGRectMake(0, 20, KscreenWidth, 44);
    
    // label 当日新闻label
    UILabel * todayLabel  = [[UILabel alloc]init];
    todayLabel.text = @"今日新闻";
    todayLabel.textColor = [UIColor whiteColor];
    todayLabel.textAlignment = NSTextAlignmentCenter;
    todayLabel.font = [UIFont systemFontOfSize:20];
    self.todayShowLabel = todayLabel;
    [self.view addSubview:todayLabel];
    [todayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(naviBarBottomView);
        make.size.mas_equalTo(CGSizeMake(200, 40));
    }];
    
    UIButton * homeIcon = [[UIButton alloc]init];
    [self.view addSubview:homeIcon];
    [homeIcon setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
    [homeIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(15);
        make.centerY.equalTo(todayLabel.mas_centerY);
        make.size.mas_equalTo(CGSizeMake(20, 20));
    }];
    
    // 处理navibar下面那一截 的显示和隐藏
    [[self.viewModel.hiddenNaviBottomSubject distinctUntilChanged]subscribeNext:^(id x) {
        if ([x boolValue]) {
            self.naviBarBottom.hidden = YES;
            self.todayShowLabel.hidden = YES;
        }else{
            self.naviBarBottom.hidden = NO;
            self.todayShowLabel.hidden = NO;
        }
    }];
    
    
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
