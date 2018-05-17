### RunloopTaskManager
> 支持创建task任务，已添加的task将会在主线程Runloop进入休眠之前被执行，并且每次Runloop只执行一个task，达到必须在主线程执行的繁重的任务延后执行的目的，经过测试，在频繁快速的滚动UITableView的时候，屏幕的刷新率仍能保持在56FPS以上，对防止屏幕卡顿掉帧有良好的效果。

### CPFRunloopTaskManager

- **CPFRunloopTaskManager** 是一个单例，通过几个实例方法添加或者移除任务，默认最多添加10个任务。

```
+ (instancetype)defaultManager;
```

- 需要注意的是，移除任务必须明确某个任务对象，或者指定任务的唯一标识 **identifier**，且正在执行的任务无法移除。

```
- (void)addTaskUnit:(CPFRunloopTaskUnit *)taskUnit;
	
- (void)removeTaskUnit:(CPFRunloopTaskUnit *)taskUnit;

- (void)addTask:(CPFRunloopTask)task forIdentifier:(NSString *)identifier;
- (void)removeTaskForIdentifier:(NSString *)identifier;

- (void)removeAllTaskUnit;

```
- 已添加的任务支持暂停和恢复执行，正在执行的任务无法暂停。

```
- (void)suspend;
- (void)resume;
```

- 支持通过为主线程Runloop添加一个Source0的方式，来立即出发一个新任务。

```
- (void)executeTask:(CPFRunloopTask)task;
```

### CPFRunloopTask

- CPFRunloopTaskManager 中添加的任务，都是 **CPFRunloopTaskUnit** 实例对象。
- CPFRunloopTaskUnit 对象通过指定初始化方法 *-initTaskUnit:forIdentifier:*  创建。第一个参数是一个返回布尔值的Block，用来包裹要执行的任务，任务执行结束返回Yes，否则返回No；第二个参数是任务的唯一标识符，用于移除任务。


### 用法

- 添加任务

```
CPFRunloopTaskUnit *taskUnit_1 = [[CPFRunloopTaskUnit alloc] initTaskUnit:^BOOL{
        NSLog(@"正在执行 taskUnit_1");
        return YES;
    } forIdentifier:@"taskUnit_1"];
[[CPFRunloopTaskManager defaultManager] addTaskUnit:taskUnit_1];
```

- 暂停任务

```
[[CPFRunloopTaskManager defaultManager] suspend];
```

- 移除任务

```
[[CPFRunloopTaskManager defaultManager] removeTaskForIdentifier:@"taskUnit_4"];
```

### 关于Demo

Demo 中使用一个UITableView模拟任务的频繁触发，在Cell将要出现的时候添加绘制任务，在Cell消失的时候移除绘制的视图。CPFRunloopTaskManager会在UITableView停止滚动的时候开始顺序执行添加的任务。每个任务花费一个Runloop的循环，防止任务卡顿主线程，通过这种延后执行的方式提高屏幕刷新率。