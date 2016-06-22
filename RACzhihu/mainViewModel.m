//
//  mainViewModel.m
//  RACzhihu
//
//  Created by zhn on 16/6/21.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "mainViewModel.h"
#import "zhnZhihuWebManager+mainVC.h"
#import "mainModel.h"
#import "SDCycleScrollView.h"

@interface mainViewModel()<UITableViewDataSource>

@end


@implementation mainViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        // 初始化绑定
        [self initialBlind];
    }
    return self;
}


- (void)initialBlind{
    
    _todayStatusCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        SDCycleScrollView * bannerView = (SDCycleScrollView *)input;
        
        RACSignal * requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [[zhnZhihuWebManager share]getMainLatestStatusSuccess:^(id success) {
                
                NSArray * banerArray = [NSArray yy_modelArrayWithClass:[mainModel class] json:success[@"top_stories"]];
                
                NSArray * todayArray = [NSArray yy_modelArrayWithClass:[mainModel class] json:success[@"stories"]];
                
                NSMutableArray * imageArray = [NSMutableArray array];
                NSMutableArray * titleArray = [NSMutableArray array];
                for (mainModel * tempModel in banerArray) {
                    [imageArray addObject:tempModel.image];
                    [titleArray addObject:tempModel.title];
                }
                bannerView.imageURLStringsGroup = imageArray;
                bannerView.titlesGroup = titleArray;
                
                
                [subscriber sendNext:KzhnSuccess];
                [subscriber sendCompleted];
                
            } error:^(id error) {
                
                [subscriber sendNext:KzhnError];
                [subscriber sendCompleted];
                
            }];
            
            return nil;
        }];
        return requestSignal;
    }];
    
    @weakify(self)
    _dataSourceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        UITableView * mainTableView = (UITableView *)input;
        mainTableView.dataSource = self;
       return [mainTableView rac_valuesAndChangesForKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew observer:self];
    }];

}

#pragma mark -  datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"adad";
    return cell;
}



@end
