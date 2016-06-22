//
//  launchViewController.m
//  
//
//  Created by zhn on 16/6/21.
//
//

#import "launchViewController.h"
#import "launchViewModel.h"
#import "launchModel.h"

@interface launchViewController ()

@property (nonatomic,strong) launchViewModel * launchModel;

@end

@implementation launchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * backImageView = [[UIImageView alloc]init];
    backImageView.image = [UIImage imageNamed:@"zhihuLaunchImage"];
    backImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:backImageView];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    
    UIImageView * showImageView = [[UIImageView alloc]init];
    showImageView.alpha = 0.7;
    [self.view addSubview:showImageView];
    showImageView.contentMode = UIViewContentModeScaleAspectFill;
    [showImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    UILabel * authorLabel = [[UILabel alloc]init];
    [self.view addSubview:authorLabel];
    authorLabel.textAlignment = NSTextAlignmentCenter;
    authorLabel.textColor = [UIColor whiteColor];
    authorLabel.font = [UIFont systemFontOfSize:11];
    [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(100, 20));
        make.bottom.equalTo(self.view.mas_bottom).with.offset(-10);
    }];
   
    UIImageView * maskView = [[UIImageView alloc]init];
    maskView.alpha = 0.3;
    [self.view addSubview:maskView];
    maskView.backgroundColor = [UIColor blackColor];
    [maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsZero);
    }];
    
    // 事件处理
    [self.launchModel.launchCommand execute:@[showImageView,authorLabel,self]];
    
}

- (launchViewModel *)launchModel{
    
    if (_launchModel == nil) {
        _launchModel = [[launchViewModel alloc]init];
    }
    return _launchModel;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
