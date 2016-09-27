//
//  LXTaskListViewController.m
//  SpeedList
//
//  Created by 李想 on 16/9/21.
//  Copyright © 2016年 BAT. All rights reserved.
//

#import "LXTaskListViewController.h"
#import "AddTaskViewController.h"
#import "TaskModel.h"
#import "LXTaskCell.h"
#import "Utils.h"
#import "LXListSectionFooterView.h"
#define Path [NSHomeDirectory() stringByAppendingFormat:@"/Documents/User/%@/Tasks/%@",[CurrentUser objectForKey:@"username"],self.listTitle]

@interface LXTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,LXListSectionFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *completedTasks;
@end

@implementation LXTaskListViewController
#pragma mark Method About Main View


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = self.listTitle;
    if (self.isAllowToAdd) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"添加任务" style:UIBarButtonItemStyleDone target:self action:@selector(addTaskAction)];
    }
    [self.tableView registerNib:[UINib nibWithNibName:@"LXTaskCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"cell"];

    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadTasksWithBundle];
}



-(void)addTaskAction{
    AddTaskViewController *add = [[AddTaskViewController alloc]init];
    add.hidesBottomBarWhenPushed = YES;
    add.taskType = self.listTitle;
    [self.navigationController pushViewController:add animated:YES];
}
-(void)loadTasks{
    BmobQuery *query = [BmobQuery queryWithClassName:@"MyTask"];
    [query whereKey:@"type" equalTo:self.listTitle];
    [query includeKey:@"user"];
    [query whereKey:@"user" equalTo:[BmobUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (array) {
            self.tasks = [array mutableCopy];
            [self.tableView reloadData];
        }else{
            NSLog(@"%@",error);
        }
    }];
}

-(void)loadTasksWithBundle{
    self.tasks = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSLog(@"%@",Path);
    NSArray *taskNames = [fm contentsOfDirectoryAtPath:Path error:nil];
    for (NSString *taskName in taskNames) {
        if (![taskName containsString:@"."]) {
            NSString *taskPath = [Path stringByAppendingPathComponent:taskName];
            NSData *taskData = [NSData dataWithContentsOfFile:taskPath];
            TaskModel *task = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
            if (!task.isCompleted) {
                [self.tasks addObject:task];
            }
            
        }
        
    }
    [self.tableView reloadData];
    
}
-(void)showCompletedTasks{
    if (!self.completedTasks.count) {
        self.completedTasks = [NSMutableArray array];
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *taskNames = [fm contentsOfDirectoryAtPath:Path error:nil];
        for (NSString *taskName in taskNames) {
            if (![taskName containsString:@"."]) {
                NSString *taskPath = [Path stringByAppendingPathComponent:taskName];
                NSData *taskData = [NSData dataWithContentsOfFile:taskPath];
                TaskModel *task = [NSKeyedUnarchiver unarchiveObjectWithData:taskData];
                if (task.isCompleted == YES)
                    [self.completedTasks addObject:task];
            }
        }
        [self.tableView reloadData];
    }else{
        self.completedTasks = nil;
        [self.tableView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark <UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0)
        return self.tasks.count;
    return self.completedTasks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    LXTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if(indexPath.section == 0)
        cell.taskModel = self.tasks[indexPath.row];
    else
        cell.taskModel = self.completedTasks[indexPath.row];
    cell.finishBlock = ^(TaskModel *task){
        if (task.isCompleted) {
            [self.completedTasks removeObject:task];
        }else{
            [self.tasks removeObject:task];
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        task.isCompleted = !task.isCompleted;
        [Utils saveTaskStatusWithTask:task];
        if (!task.isCompleted) {
            [self loadTasksWithBundle];
        }
    };
    return cell;
}
-(UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        LXListSectionFooterView *foot = [[NSBundle mainBundle]loadNibNamed:@"LXListSectionFooterView" owner:self options:nil].firstObject;
        foot.delegate = self;
        return foot;
    }
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == 0 )
        return 44;
    return 0;
}
#pragma mark <UITableViewDelegate>
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    AddTaskViewController *add = [[AddTaskViewController alloc]init];
    if (indexPath.section == 0) {
        add.task = self.tasks[indexPath.row];
    }else{
        add.task = self.completedTasks[indexPath.row];
    }
    add.taskType = self.listTitle;
    [self.navigationController pushViewController:add animated:YES];
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
