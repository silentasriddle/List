//
//  SetUserInfoViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/16.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "SetUserInfoViewController.h"
#import <MBProgressHUD.h>
@interface SetUserInfoViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headIV;
@property (weak, nonatomic) IBOutlet UITextField *nickTf;
@property (nonatomic,strong)NSData *headData;
@end

@implementation SetUserInfoViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction)];
}
-(void)finishAction{
    BmobUser *user = [BmobUser currentUser];
    [user setObject:self.nickTf.text forKey:@"nick"];
    if (self.headData) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.mode = MBProgressHUDModeDeterminate;
        hud.label.text = @"正在上传头像...";
        [BmobFile filesUploadBatchWithDataArray:@[@{@"filename":@"head.jpg",@"data":self.headData}] progressBlock:^(int index, float progress) {
            hud.progress = progress;
        } resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                BmobFile *file = array.firstObject;
                [user setObject:file.url forKey:@"headPath"];
                [hud hideAnimated:YES];
                [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }else{
                        NSLog(@"%@",error);
                    }
                }];
            }
        }];
    }else{
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self.navigationController popViewControllerAnimated:YES];
            }
        }];
    }
}
#pragma mark Method About Set Head
- (IBAction)tapAction:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc]init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    [self presentViewController:picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    NSString *path = [info[UIImagePickerControllerReferenceURL]description];
    if ([path hasSuffix:@"png"]) {
        self.headData = UIImagePNGRepresentation(image);
    }else{
        self.headData = UIImageJPEGRepresentation(image, .5);
    }
    self.headIV.image = image;
    [self dismissViewControllerAnimated:YES completion:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
