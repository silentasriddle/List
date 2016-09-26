//
//  LXTaskCell.m
//  SpeedList
//
//  Created by 李想 on 16/9/24.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "LXTaskCell.h"

@implementation LXTaskCell
-(void)setTask:(BmobObject *)task{
    _task = task;
    self.titleLabel.text = [task objectForKey:@"title"];
    if ([[task objectForKey:@"isCompleted"]boolValue]) {
        self.markBtn.selected = YES;
        self.isCompleted = YES;
    }
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor whiteColor];
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    // Initialization code
}
-(void)layoutSubviews{
    CGRect frame = self.contentView.frame;
    frame.size.height = self.frame.size.height - 3;
    frame.origin.x = 5;
    frame.size.width = self.frame.size.width - 10;
    self.contentView.frame = frame;
}
- (IBAction)finishBtnClick:(UIButton*)sender {
    sender.selected = !sender.isSelected;
    if (!self.isCompleted) {
        self.finishBlock(self.task);
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
