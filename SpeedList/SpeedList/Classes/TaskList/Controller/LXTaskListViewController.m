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
#define DocuPath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Tasks"]
#define Path(taskName) [NSString stringWithFormat:@"%@/%@",self.listTitle,taskName]
@interface LXTaskListViewController ()<UITableViewDelegate,UITableViewDataSource,LXListSectionFooterViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *completedTasks;
@end

@implementation LXTaskListViewController
#pragma mark Method About Main View
-(void)setTasks:(NSMutableArray *)tasks{
    _tasks = tasks;
    NSMutableArray *completed = [NSMutableArray array];
    for (BmobObject *task in tasks) {
        if ([[task objectForKey:@"isCompleted"]boolValue]) {
            [completed addObject:task];
        }
    }
    [_tasks removeObjectsInArray:completed];
}
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
    if(!self.tasks)
        [self loadTasks];
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
    NSData *data = [NSData dataWithContentsOfFile:[NSHomeDirectory() stringByAppendingString:[NSString stringWithFormat:@"Documents/%@.arch",self.listTitle]]];
    self.tasks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [self.tableView reloadData];
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
        cell.task = self.tasks[indexPath.row];
    else
        cell.task = self.completedTasks[indexPath.row];
    cell.finishBlock = ^(BmobObject *task){
        [task setObject:@(YES) forKey:@"isCompleted"];
        [task setObject:[BmobUser currentUser] forKey:@"user"];
        [task updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                NSLog(@"已完成");
            }
        }];
        [self.tasks removeObject:task];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
-(void)showCompletedTasks{
    if (self.completedTasks.count == 0) {
        BmobQuery *query = [BmobQuery queryWithClassName:@"MyTask"];
        [query whereKey:@"user" equalTo:CurrentUser];
        [query whereKey:@"isCompleted" equalTo:@(YES)];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            self.completedTasks = [array mutableCopy];
            [self.tableView reloadData];
        }];
    }else{
        self.completedTasks = nil;
        [self.tableView reloadData];
    }
    
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
        add.task = [[TaskModel alloc]initWithBmobObject:self.tasks[indexPath.row]];
    }else{
        add.task = [[TaskModel alloc]initWithBmobObject:self.completedTasks[indexPath.row]];
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
