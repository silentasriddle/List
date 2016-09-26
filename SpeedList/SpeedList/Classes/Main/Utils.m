//
//  Utils.m
//  SpeedList
//
//  Created by 李想 on 16/9/17.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "Utils.h"
#import <MBProgressHUD.h>
#import "TaskModel.h"
@implementation Utils
+(void)cacheTaskWithTask:(BmobObject*)task andPhotos:(NSArray *)photos{
    if (photos.count > 0) {
        NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:photos.count];
        for (UIImageView *imgView in photos) {
            UIImage *image = imgView.image;
            NSData *data = UIImageJPEGRepresentation(image, .5);
            NSDictionary *dataDic = @{@"filename":@"img.png",@"data":data};
            [dataArr addObject:dataDic];
        }
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:Application.keyWindow animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        [BmobFile filesUploadBatchWithDataArray:dataArr progressBlock:^(int index, float progress) {
            hud.label.text = [NSString stringWithFormat:@"%d/%ld",index + 1,dataArr.count];
            hud.progress = progress;
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            NSMutableArray *imgPaths = [NSMutableArray arrayWithCapacity:array.count];
            for (BmobFile *file in array) {
                [imgPaths addObject:file.url];
            }
            [hud hideAnimated:YES];
            [task setObject:imgPaths forKey:@"imagePaths"];
            [task updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"保存照片成功");
                }
            }];
        }];
    }else{
        [task setObject:@[] forKey:@"imagePaths"];
        [task updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"保存照片信息成功");
            }
        }];
    }
}
+(void)archiveTaskWithPath:(NSString *)path andPhotos:(NSArray *)photos andTask:(BmobObject *)task{
    NSMutableArray *photoDatas = [NSMutableArray array];
    for (UIImageView *imgView in photos) {
        NSData *photoData = UIImageJPEGRepresentation(imgView.image, .5);
        [photoDatas addObject:photoData];
    }
    TaskModel *model = [[TaskModel alloc]initWithBmobObject:task];
    model.photoDatas = [photoDatas copy];
    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
    [modelData writeToFile:path atomically:YES];
}
@end
