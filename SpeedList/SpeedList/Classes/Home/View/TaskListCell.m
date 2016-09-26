//
//  TaskListCell.m
//  SpeedList
//
//  Created by 李想 on 16/9/17.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "TaskListCell.h"
@interface TaskListCell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *numLabel;

@end
@implementation TaskListCell
-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLabel.text = title;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.numLabel.layer.cornerRadius = self.numLabel.bounds.size.height / 2;
    self.numLabel.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
