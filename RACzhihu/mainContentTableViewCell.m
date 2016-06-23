//
//  mainContentTableViewCell.m
//  RACzhihu
//
//  Created by zhn on 16/6/23.
//  Copyright © 2016年 zhn. All rights reserved.
//

#import "mainContentTableViewCell.h"

@interface mainContentTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *contentCellShowImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end



@implementation mainContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
       self =  [[[NSBundle mainBundle]loadNibNamed:@"mainContentTableVIewCell" owner:self options:nil]lastObject];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void)setStatusModel:(mainModel *)statusModel{
    _statusModel = statusModel;
    [self.contentCellShowImageView sd_setImageWithURL:[NSURL URLWithString:[statusModel.images firstObject]]];
    self.contentLabel.text = statusModel.title;
}



@end
