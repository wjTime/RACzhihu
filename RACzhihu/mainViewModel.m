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
#import "mainContentTableViewCell.h"

static const CGFloat KcellHeight = 90;

@interface mainViewModel()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong) UITableView * mainTableView;

@property (nonatomic,strong) NSMutableArray * contentStatusArray;

@property (nonatomic,strong) NSMutableArray * currentDateArray;

@property (nonatomic,strong) NSMutableArray * storyIdArray;

@property (nonatomic,copy) NSArray * bannerArray;

@property (nonatomic,copy) NSString * currentLoadDate;

@property (nonatomic,getter = isLoading) BOOL loading;
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
    
    @weakify(self)
    _todayStatusCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        SDCycleScrollView * bannerView = (SDCycleScrollView *)input;
        bannerView.delegate = self;
        
        RACSignal * requestSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [[zhnZhihuWebManager share]getMainLatestStatusSuccess:^(id success) {
                @strongify(self)
                _currentLoadDate = success[@"date"];
                
                [self.currentDateArray addObject:success[@"date"]];
                
                NSArray * banerArray = [NSArray yy_modelArrayWithClass:[mainModel class] json:success[@"top_stories"]];
                self.bannerArray = banerArray;
                
                NSArray * todayArray = [NSArray yy_modelArrayWithClass:[mainModel class] json:success[@"stories"]];
                
                // 添加一波story的id 为了滑动上一组下一组做准备
                for (mainModel * tempModel in todayArray) {
                    [self.storyIdArray addObject:tempModel.id];
                }
                
                [self.contentStatusArray addObject:todayArray];
            
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
    
    
    _dataSourceCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        UITableView * mainTableView = (UITableView *)input;
        mainTableView.dataSource = self;
        mainTableView.delegate = self;
        self.mainTableView = mainTableView;
        return [mainTableView rac_valuesAndChangesForKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew observer:self];
    }];
    
    _hiddenNaviBottomSubject = [RACSubject subject];
    _pushSubject = [RACSubject subject];
    _bannerSubject = [RACSubject subject];
}


- (NSMutableArray *)contentStatusArray{
    
    if (_contentStatusArray == nil) {
        _contentStatusArray = [NSMutableArray array];
    }
    return _contentStatusArray;
}

- (NSMutableArray *)currentDateArray{
    if (_currentDateArray == nil) {
        _currentDateArray = [NSMutableArray array];
    }
    return _currentDateArray;
}

- (NSMutableArray *)storyIdArray{
    
    if (_storyIdArray == nil ) {
        _storyIdArray = [NSMutableArray array];
    }
    return _storyIdArray;
}

#pragma mark -  datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.contentStatusArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSArray * statusArray = self.contentStatusArray[section];
    return statusArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    mainContentTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"mainCell"];
    if (cell == nil) {
        cell = [[mainContentTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mainCell"];
    }
    NSArray * sectionArray = self.contentStatusArray[indexPath.section];
    cell.statusModel = sectionArray[indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return KcellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        UIView * headView = [[UIView alloc]init];
        headView.frame = CGRectMake(0, 0, 0, 40);
        headView.backgroundColor = zhnColor(0, 137, 211, 1);
        UILabel * dateLabel = [[UILabel alloc]init];
        [headView addSubview:dateLabel];
        dateLabel.text = self.currentDateArray[section];
        dateLabel.font = [UIFont systemFontOfSize:20];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(headView);
            make.size.mas_equalTo(CGSizeMake(300, 30));
        }];
        return headView;
    }else{
        return nil;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section > 0) {
        return 44;
    }else{
        return 0;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_loading == NO) {
        
        if ((self.mainTableView.contentSize.height - self.mainTableView.contentOffset.y) <= self.mainTableView.zhn_height) {
            _loading = YES;
            @weakify(self)
            [[zhnZhihuWebManager share]getCurrtentDayStatus:self.currentLoadDate success:^(id success) {
                @strongify(self)
                self.currentLoadDate = success[@"date"];
                [self.currentDateArray addObject:success[@"date"]];
                NSArray * currtentContentStatus = [NSArray yy_modelArrayWithClass:[mainModel class] json:success[@"stories"]];
                for (mainModel * tempModel in currtentContentStatus) {
                    [self.storyIdArray addObject:tempModel.id];
                }
                [self.contentStatusArray addObject:currtentContentStatus];
                NSIndexSet * count = [NSIndexSet indexSetWithIndex:self.contentStatusArray.count - 1] ;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.mainTableView insertSections:count withRowAnimation:UITableViewRowAnimationFade];
                });
                _loading = NO;
            } error:^(id error) {
                _loading = NO;
            }];
        }
    }
    
    NSArray * todayArray = [self.contentStatusArray firstObject];
    CGFloat hiddenOffsetY = todayArray.count * KcellHeight + 250;// 这个250 就是轮播图的高度要算上去的实际写代码的时候这个肯定要携程一个常量放到config里面的这里我懒得写啦
    if (scrollView.contentOffset.y >= hiddenOffsetY) {
        [self.hiddenNaviBottomSubject sendNext:@(YES)];
    }else{
        [self.hiddenNaviBottomSubject sendNext:@(NO)];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray * sectionArray = self.contentStatusArray[indexPath.section];
    mainModel * currentModel = sectionArray[indexPath.row];
    [_pushSubject sendNext:@[currentModel,self.storyIdArray]];
}

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    [_bannerSubject sendNext:@[self.bannerArray[index],self.storyIdArray]];
}


@end
