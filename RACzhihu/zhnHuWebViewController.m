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
#import "WebViewJavascriptBridge.h"


@interface zhnHuWebViewController ()<UIWebViewDelegate>

@property (nonatomic,strong) zhihuWebViewControllerModel  * viewModel;

@property (nonatomic,strong) zhihuWebViewModel * model;

@property (nonatomic,strong) NSMutableArray * allImagesOfThisArticle;

@property (nonatomic,strong) WebViewJavascriptBridge * bridge;

@property (nonatomic,weak) UIImageView * contentImageView;
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
    _bridge  = [WebViewJavascriptBridge bridgeForWebView:contentWebView];
    [_bridge setWebViewDelegate:self];
   
    @weakify(self)
    [_bridge registerHandler:@"imagJavascriptHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        [self downloadAllImagesInNative:data];
        
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
        NSString * newBody = [model.body stringByReplacingOccurrencesOfString:@"src" withString:@"esrc"];
        NSString * htmlStr = [NSString stringWithFormat:@"<html><head> <script type=\"text/javascript\" src=\"test.js\"></script><link rel=\"stylesheet\" href=%@></head><body onload = \"loadHtml()\"> %@ </body></html>",model.css[0],newBody];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [contentWebView loadHTMLString:htmlStr baseURL:[NSURL fileURLWithPath:[[NSBundle mainBundle]bundlePath]]];
        });
        
    }];
    
    [self.viewModel.scrollCommand execute:@[headImageView,previousStoryView,arrowImageView,self.view,self.delegateSubject]];
    
    
    [_bridge registerHandler:@"showImage" handler:^(id data, WVJBResponseCallback responseCallback) {
        @strongify(self)
        if (!self.contentImageView) {
            
            UIImageView * contentShowImage = [[UIImageView alloc]init];
            contentShowImage.userInteractionEnabled = YES;
            [self.view addSubview:contentShowImage];
            UIImage * currentImage = [UIImage imageWithContentsOfFile:data];
            contentShowImage.image = currentImage;
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissContentImage)];
            self.contentImageView = contentShowImage;
            [contentShowImage addGestureRecognizer:tap];
            CGFloat width = currentImage.size.width;
            CGFloat height = currentImage.size.height;
            
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                
                CGFloat fitWidth;
                CGFloat fitHeight;
                CGFloat scaleW = width / KscreenWidth;
                CGFloat scaleH = height / KscreenHeight;
                
                if (scaleW > scaleH) {
                    fitWidth = KscreenWidth;
                    fitHeight = height / scaleW;
                }else{
                    fitHeight = KscreenHeight;
                    fitWidth = width / scaleH;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [contentShowImage mas_makeConstraints:^(MASConstraintMaker *make) {
                        
                        make.center.equalTo(self.view);
                        make.height.mas_equalTo(fitHeight);
                        make.width.mas_equalTo(fitWidth);
                        
                    }];
                    
                    contentShowImage.transform = CGAffineTransformMakeScale(0, 0);
                    [UIView animateWithDuration:0.3 animations:^{
                        contentShowImage.transform = CGAffineTransformIdentity;
                    }];
                });
            });

        }
   
    }];
        
    
}

- (void)dismissContentImage{

    [UIView animateWithDuration:0.3 animations:^{
        self.contentImageView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self.contentImageView removeFromSuperview];
    }];
    
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

#pragma mark -- 下载全部图片
-(void)downloadAllImagesInNative:(NSArray *)imageUrls{
    
 
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        //初始化一个置空元素数组
        _allImagesOfThisArticle = [NSMutableArray arrayWithCapacity:imageUrls.count];//本地的一个用于保存所有图片的数组
        for (NSUInteger i = 0; i < imageUrls.count-1; i++) {
            [_allImagesOfThisArticle addObject:[NSNull null]];
        }
        
        for (NSUInteger i = 0; i < imageUrls.count-1; i++) {
            NSString *_url = imageUrls[i];
            
            [manager downloadImageWithURL:[NSURL URLWithString:_url] options:SDWebImageHighPriority progress:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                
                if (image) {
                    
                    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                        
                        //把图片在磁盘中的地址传回给JS
                        NSString *key = [manager cacheKeyForURL:imageURL];
                        //本地路径
                        NSString * source = [[SDImageCache sharedImageCache] defaultCachePathForKey:key];
                        
                        [_bridge callHandler:@"imagesDownloadComplete" data:@[key,source]];
                        
                    });
                    
                }
                
            }];
            
        }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
