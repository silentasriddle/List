//
//  LXListSectionFooterView.h
//  SpeedList
//
//  Created by 李想 on 16/9/25.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LXListSectionFooterView;
@protocol LXListSectionFooterViewDelegate <NSObject>

-(void)showCompletedTasks;

@end
@interface LXListSectionFooterView : UIView
@property (nonatomic,weak)id delegate;
@end
