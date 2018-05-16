//
//  ViewController.m
//  CPFRunloopDemo
//
//  Created by JWTHiOS02 on 2018/5/15.
//  Copyright © 2018年 cuipengfei. All rights reserved.
//

#import "ViewController.h"
#import "CPFRunloopTaskManager.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = @[@"1",@"2",@"3",@"4"].mutableCopy;
    
    [self simulateTask];
    
    [self setupTableView];
}

- (void)simulateTask  {
    NSLog(@"正在载入任务");
    
    CPFRunloopTaskUnit *taskUnit_1 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        NSLog(@"正在执行 taskUnit_1");
        return YES;
    } forIdentifier:@"taskUnit_1"];
    [[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_1];
    
    CPFRunloopTaskUnit *taskUnit_2 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        
        // 暂停执行任务5秒
        [[CPFRunloopTaskManager defaultManager] suspend];
        [self performSelector:@selector(resume) withObject:nil afterDelay:5];
        
        NSLog(@"正在执行 taskUnit_2");
        return YES;
    } forIdentifier:@"taskUnit_2"];
    [[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_2];
    
    CPFRunloopTaskUnit *taskUnit_3 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        
        NSLog(@"正在执行 taskUnit_3");
        return YES;
    } forIdentifier:@"taskUnit_3"];
    [[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_3];
    
    CPFRunloopTaskUnit *taskUnit_4 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        NSLog(@"正在执行 taskUnit_4");
        [self.dataSource addObject:@"5"];
        [self.tableView reloadData];
        return YES;
    } forIdentifier:@"taskUnit_4"];
    [[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_4];
    
    
    CPFRunloopTaskUnit *taskUnit_5 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        NSLog(@"正在执行 taskUnit_5");
        return YES;
    } forIdentifier:@"taskUnit_5"];
    [[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_5];
    
    // 移除未执行的任务
    // [[CPFRunloopTaskManager defaultManager] removeTaskForIdentifier:@"taskUnit_4"];
}

- (void)resume {
    [[CPFRunloopTaskManager defaultManager] resume];
}

- (void)executeTask {
    [[CPFRunloopTaskManager defaultManager] executeTask:^BOOL{
        NSLog(@"立即执行");
        return YES;
    }];
}

- (void)setupTableView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"test"];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"发送通知" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(executeTask) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"载入任务" forState:UIControlStateNormal];
    [rightBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(simulateTask) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test"];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.dataSource removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
}

@end
