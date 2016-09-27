	//
//  AddTaskViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/21.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "AddTaskViewController.h"
//#import "BmobObject+LXTask.h"
#import "RemarkViewController.h"
#import <MBProgressHUD.h>
#import <UIImageView+WebCache.h>
#import "Utils.h"
#define ImageHeight 100
#define Margin 5
#define RowHeight 44
#define FileDirectoryPath [NSString stringWithFormat:@"User/%@/Tasks/%@",CurrentUser.username,self.taskType]
@interface AddTaskViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell *titleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *dateCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *wakeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *remarkCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *photoCell;
@property (nonatomic,strong)NSArray *cells;
@property (weak, nonatomic) IBOutlet UILabel *taskDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *wakeTimeLabel;
@property (nonatomic,strong)UIDatePicker *datePicker;
@property (nonatomic,strong)UIDatePicker *timePicker;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;
@property (weak, nonatomic) IBOutlet UITextField *titleTF;
@property (nonatomic,strong)NSMutableArray *photos;
@property (nonatomic)BOOL isPhotosChanged;
@property (nonatomic,copy)NSString *filePath;
@end

@implementation AddTaskViewController
-(NSMutableArray *)photos{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }return _photos;
}
-(NSString *)filePath{
    NSString *fileName = _titleTF.text.length > 0 ? _titleTF.text : self.task.title;
    NSString *path = [[self finalPath:FileDirectoryPath] stringByAppendingPathComponent:fileName];
    return path;
}
#pragma mark Method About MainView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.cells = @[_titleCell,_dateCell,_wakeCell,_remarkCell,_photoCell];
    if (self.task) {
        self.title = self.task.title;
        for (NSString *imagePath in self.task.imagePaths) {
            UIImageView *imgView = [[UIImageView alloc]init];
            [imgView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:LoadingImage];
            [self.photos addObject:imgView];
            [self loadPhotoswithCount:self.photos.count - 1 andImageView:imgView];
        }
    }else{
        self.title = @"添加任务";
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishAction:)];
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}


-(NSString *)finalPath:(NSString*)directoryName{
    NSString *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *finalPath = [doc stringByAppendingPathComponent:directoryName];
    [fm createDirectoryAtPath:finalPath withIntermediateDirectories:YES attributes:nil error:nil];
    return finalPath;
}

-(void)finishAction:(UIBarButtonItem*)item{
    if ([item.title isEqualToString:@"结束编辑"]) {
        for (UIImageView *imgView in self.photos) {
            for (UIView *view in imgView.subviews) {
                if ([view isMemberOfClass:[UIButton class]]) {
                    [view removeFromSuperview];
                }
            }
        }
        item.title = @"完成";
        return;
    }
    if (self.task) {
        BmobQuery *query = [BmobQuery queryWithClassName:@"MyTask"];
        [query getObjectInBackgroundWithId:self.task.bmobTaskID block:^(BmobObject *object, NSError *error) {
            if (object) {
                [self updateBmobObjectWithTask:object];
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        BmobObject *task = [BmobObject objectWithClassName:@"MyTask"];
        [self updateBmobObjectWithTask:task];
    }
    self.navigationItem.rightBarButtonItem.title = @"";
}
-(void)updateBmobObjectWithTask:(BmobObject*)task{
    NSDateFormatter *dayDF = [[NSDateFormatter alloc]init];
    dayDF.dateFormat = @"yyyy-MM-dd";
    NSDate *taskDate = [dayDF dateFromString:self.taskDateLabel.text];
    NSDateFormatter *timeDF = [[NSDateFormatter alloc]init];
    timeDF.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *wakeTime = [timeDF dateFromString:_wakeTimeLabel.text];
    [task setObject:self.titleTF.text forKey:@"title"];
    [task setObject:taskDate forKey:@"taskDate"];
    [task setObject:wakeTime forKey:@"wakeTime"];
    [task setObject:self.taskType forKey:@"type"];
    NSNumber *isCompleted = self.task ? @(NO) : @(self.task.isCompleted);
    [task setObject:isCompleted forKey:@"isCompleted"];
    [task setObject:[BmobUser currentUser] forKey:@"user"];
    [task setObject:self.remarkLabel.text forKey:@"remark"];
    //将任务模型进行本地数据持久化
    [Utils archiveTaskWithPath:self.filePath andPhotos:self.photos andTask:task];
    if (self.task) {
        [task updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [Utils archiveTaskWithPath:self.filePath andPhotos:self.photos andTask:task];
            if (isSuccessful && self.isPhotosChanged) {
                
                [Utils cacheTaskWithTask:task andPhotos:self.photos];
            }else{
                NSLog(@"%@",error);
            }
        }];
    }else{
        [task saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            [Utils archiveTaskWithPath:self.filePath andPhotos:self.photos andTask:task];
            if (isSuccessful && self.isPhotosChanged) {
                [Utils cacheTaskWithTask:task andPhotos:self.photos];
            }
        }];
    }
}
#pragma mark <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.task) {
        self.titleTF.text = self.task.title;
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        df.dateFormat = @"yyyy-MM-dd";
        self.taskDateLabel.text = [df stringFromDate:self.task.taskDate];
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.wakeTimeLabel.text = [df stringFromDate:self.task.wakeTime];
        self.remarkLabel.text = self.task.remark;
    }
    return self.cells[indexPath.row];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == self.cells.count - 2) {
        return RowHeight * 2;
    }
    if (indexPath.row == self.cells.count - 1) {
        return self.photos.count * ImageHeight + Margin + RowHeight;
    }
    return RowHeight;
}
#pragma mark <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isEqual:self.dateCell]) {
        [self.datePicker removeFromSuperview];
    }else if ([cell isEqual:self.wakeCell]){
        [self.timePicker removeFromSuperview];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
            [self.titleTF becomeFirstResponder];
            break;
        case 1:{
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,LXSH , LXSW, 200)];
            self.datePicker = datePicker;
            datePicker.backgroundColor = [UIColor whiteColor];
            [self.timePicker removeFromSuperview];
            [self.view addSubview:datePicker];
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.tag = 1;
            datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
            [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
            [UIView animateWithDuration:.5 animations:^{
                datePicker.frame = CGRectMake(0, LXSH - 200, LXSW, 200);
            }];
        }
            break;
        case 2:{
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0,LXSH , LXSW, 200)];
            self.timePicker = datePicker;
            datePicker.backgroundColor = [UIColor whiteColor];
            [self.datePicker removeFromSuperview];
            [self.view addSubview:datePicker];
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            datePicker.locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_CN"];
            [datePicker addTarget:self action:@selector(datePickerAction:) forControlEvents:UIControlEventValueChanged];
            [UIView animateWithDuration:.5 animations:^{
                datePicker.frame = CGRectMake(0, LXSH - 200, LXSW, 200);
            }];
        }
            break;
        case 3:{
            RemarkViewController *remark = [[RemarkViewController alloc]init];
            remark.callback = ^(id obj){
                self.remarkLabel.text = obj;
            };
            remark.text = self.remarkLabel.text;
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:remark];
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        default:{
            UIImagePickerController *picker = [[UIImagePickerController alloc]init];
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
            break;
    }
    if (indexPath.row > 0 && self.titleTF.editing) {
        [self.view endEditing:YES];
    }
}
//选择日期
-(void)datePickerAction:(UIDatePicker*)picker{
    NSDate *date = picker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    if (picker.tag) {
        df.dateFormat = @"yyyy-MM-dd";
        self.taskDateLabel.text = [df stringFromDate:date];
    }else{
        df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        self.wakeTimeLabel.text = [df stringFromDate:date];
    }
}
-(void)loadPhotoswithCount:(NSInteger)count andImageView:(UIImageView*)imgView{
    CGRect frame = CGRectMake(0, RowHeight + (ImageHeight + Margin) * count, LXSW, 100);
    NSLog(@"%ld",count);
    imgView.frame = frame;
    imgView.contentMode = UIViewContentModeScaleAspectFill;
    imgView.clipsToBounds = YES;
    imgView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPressAction:)];
    [imgView addGestureRecognizer:lp];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
    [imgView addGestureRecognizer:tap];
    [self.photoCell addSubview:imgView];
    [self.tableView reloadData];
}
#pragma mark <UIImagePickerControllerDelegate>
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    UIImageView *imgView = [[UIImageView alloc]initWithImage:image];
    [self loadPhotoswithCount:self.photos.count andImageView:imgView];
    [self.photos addObject:imgView];
    self.isPhotosChanged = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
//点击照片做的事
-(void)tapAction:(UITapGestureRecognizer*)tap{
    
}
//长按照片做的事
-(void)longPressAction:(UILongPressGestureRecognizer*)lp{
    self.navigationItem.rightBarButtonItem.title = @"结束编辑";
    CGSize size = lp.view.frame.size;
    for (UIImageView *imgView in self.photos) {
        UIButton *deleteBtn = [[UIButton alloc]initWithFrame:CGRectMake(size.width - 30, 0, 30, 30)];
        [deleteBtn setTitle:@"X" forState:UIControlStateNormal];
        deleteBtn.tintColor = [UIColor redColor];
        [deleteBtn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        [imgView addSubview:deleteBtn];
    }
}
-(void)deleteAction:(UIButton *)btn{
    UIView *imgView = btn.superview;
    [imgView removeFromSuperview];
    NSInteger index = [self.photos indexOfObject:imgView];
    self.isPhotosChanged = YES;
    [self updatePhotosWithIndex:index];
    [self.photos removeObject:imgView];
    [self.tableView reloadData];
}
-(void)updatePhotosWithIndex:(NSInteger)index{
    for (NSInteger i = index + 1; i < self.photos.count; i ++ ) {
        UIImageView *imgView  = self.photos[i];
        CGRect frame = imgView.frame;
        frame.origin.y -= ImageHeight + Margin;
        imgView.frame = frame;
    }
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
