//
//  RemarkViewController.h
//  SpeedList
//
//  Created by 李想 on 16/9/22.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^MyCallback)(id obj);
@interface RemarkViewController : UIViewController
@property (nonatomic,copy)MyCallback callback;
@property (nonatomic,copy)NSString *text;
@end
