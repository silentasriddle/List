//
//  HomeViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/16.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "HomeViewController.h"
#import "SetUserInfoViewController.h"
#import <SVPullToRefresh.h>
#import "TaskListCell.h"
#import "NSDate+LXCompareDate.h"
#import "LXTaskListViewController.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UITableViewCell *mailCell;
@property (weak, nonatomic) IBOutlet UILabel *mailLabel;
@property (strong, nonatomic) IBOutlet UITableViewCell *todayCell;
@property (weak, nonatomic) IBOutlet UILabel *todayLabel;
@property (nonatomic,strong)NSArray *todayTasks;
@property (strong, nonatomic) IBOutlet UITableViewCell *weekCell;
@property (weak, nonatomic) IBOutlet UILabel *weekLabel;
@property (nonatomic,strong)NSArray *weekTasks;
@property (nonatomic,strong)NSMutableArray *taskCells;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSArray *constTitles;
@end

@implementation HomeViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self initUIWithLabels:@[self.mailLabel,self.todayLabel,self.weekLabel]];
    self.constTitles = @[@"收件箱",@"今天",@"本周"];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加清单" style:UIBarButtonItemStyleDone target:self action:@selector(addTaskCellAction)];
    [self.tableView registerNib:[UINib nibWithNibName:@"TaskListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];
    [self.tableView addPullToRefreshWithActionHandler:^{
        [self loadTaskCells];
        [self checkUnFinishedTasks];
    }];
    
    NSLog(@"%@",NSHomeDirectory());
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView triggerPullToRefresh];
}
-(void)viewDidAppear:(BOOL)animated{
    NSString *headPath = [CurrentUser objectForKey:@"headPath"];
    NSString *nick = [CurrentUser objectForKey:@"nick"];
    if (!(headPath && nick)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有设置头像和昵称，要去设置吗？" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            SetUserInfoViewController *set = [[SetUserInfoViewController alloc]init];
            [self.navigationController pushViewController:set animated:YES];
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];
}
-(void)initUIWithLabels:(NSArray*)labels{
    for (UILabel *label in labels) {
        label.layer.cornerRadius = label.bounds.size.height / 2;
        label.layer.masksToBounds = YES;
        label.hidden = YES;
    }
}
//检查未完成任务
-(NSDate *)localDateWithDate:(NSDate*)date{
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger seconds = [zone secondsFromGMTForDate:date];
    NSDate *localDate = [date dateByAddingTimeInterval:seconds];
    return localDate;
}
-(void)checkUnFinishedTasks{
    BmobQuery *query = [BmobQuery queryWithClassName:@"MyTask"];
    [query whereKey:@"isCompleted" notEqualTo:@(YES)];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        [self checkWeekTaskWithUnFinishedTasks:array];
        [self checkTodayTaskWIthUnFinishedTasks:array];
        [self.tableView.pullToRefreshView stopAnimating];
    }];
}
-(void)checkWeekTaskWithUnFinishedTasks:(NSArray *)tasks{
    NSMutableArray *weekTasks = [NSMutableArray array];
    for (BmobObject *task in tasks) {
        NSDate *date = [task objectForKey:@"taskDate"];
//        NSDate *current = [self localDateWithDate:[NSDate date]];
//        NSTimeInterval interval = [current timeIntervalSinceDate:date];
        if ([date isThisWeek]) {
            [weekTasks addObject:task];
        }
    }
    if(weekTasks.count > 0){
        self.weekTasks = [weekTasks copy];
        self.weekLabel.text = @(weekTasks.count).stringValue;
        self.weekLabel.hidden = NO;
    }else{
        self.weekLabel.hidden = YES;
    }
}
-(void)checkTodayTaskWIthUnFinishedTasks:(NSArray *)tasks{
    NSMutableArray *todayTasks = [NSMutableArray array];
    for (BmobObject *task in tasks) {
        NSDate *date = [task objectForKey:@"taskDate"];
//        NSDate *current = [self localDateWithDate:[NSDate date]];
//        NSTimeInterval interval = [current timeIntervalSinceDate:date];
        if ([date isToday]) {
            [todayTasks addObject:task];
        }
        
    }
    if (todayTasks.count > 0) {
        self.todayTasks = [todayTasks copy];
        self.todayLabel.text = @(todayTasks.count).stringValue;
        self.todayLabel.hidden = NO;
    }else{
        self.todayLabel.hidden = YES;
    }
}

-(void)loadTaskCells{
    BmobQuery *query = [BmobQuery queryWithClassName:@"TaskList"];
    [query whereKey:@"user" equalTo:[BmobUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            self.taskCells = [array mutableCopy];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView stopAnimating];
        }
    }];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark Methods About Task Cells 

-(void)addTaskCellAction{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"添加任务清单" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField *tf = alert.textFields.lastObject;
        BmobObject *taskObj = [BmobObject objectWithClassName:@"TaskList"];
        [taskObj setObject:tf.text forKey:@"listName"];
        [taskObj setObject:[BmobUser currentUser] forKey:@"user"];
        [taskObj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                [self.taskCells addObject:taskObj];
                [self loadTaskCells];
            }
        }];
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    [alert addAction:action2];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"输入你想要添加的清单名";
    }];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 3;
    return self.taskCells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                return self.mailCell;
            case 1:
                return self.todayCell;
            case 2:
                return self.weekCell;
        }
    }
    BmobObject *list = self.taskCells[indexPath.row];
    TaskListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.title = [list objectForKey:@"listName"];
    return cell;
}
#pragma mark <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        BmobObject *list = self.taskCells[indexPath.row];
        [self.taskCells removeObject:list];
        NSString *type = [list objectForKey:@"listName"];
        BmobQuery *query = [BmobQuery queryWithClassName:@"MyTask"];
        [query whereKey:@"type" equalTo:type];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *task in array) {
                [task deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                    if (isSuccessful) {
                        NSLog(@"任务删除成功");
                    }
                    [list deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
                        if (isSuccessful) {
                            NSLog(@"删除成功");
                            [self loadTaskCells];
                        }
                    }];
                }];
            }
        }];
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }else{
        
    }
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0) return NO;
    return YES;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LXTaskListViewController *list = [[LXTaskListViewController alloc]init];
    list.isAllowToAdd = !(indexPath.section == 0);
    list.listTitle = indexPath.section > 0 ? [self.taskCells[indexPath.row] objectForKey:@"listName"] : self.constTitles[indexPath.row];
    if (indexPath.section == 0) {
        NSArray *tasks;
        switch(indexPath.row){
            case 0:
                break;
                case 1:
                tasks = self.todayTasks;
                break;
                case 2:
                tasks = self.weekTasks;
                break;
        }
        list.tasks = [tasks mutableCopy];
    }
    list.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:list animated:YES];
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
