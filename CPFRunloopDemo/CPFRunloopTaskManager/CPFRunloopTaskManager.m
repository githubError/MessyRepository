//
//  CPFRunloopTaskManager.m
//  CPFRunloopDemo
//
//  Created by JWTHiOS02 on 2018/5/15.
//  Copyright © 2018年 cuipengfei. All rights reserved.
//

#import "CPFRunloopTaskManager.h"

#define kRunloopPortSourceNotificationName CFSTR("kRunloopPortSourceNotificationName")

@implementation CPFRunloopTaskUnit

- (instancetype)init {
    if (self = [super init]) {
        _task = nil;
        _identifier = nil;
    }
    return self;
}

- (instancetype)initTaskUnit:(CPFRunloopTask)task forIdentifier:(NSString *)identifier {
    if (self = [super init]) {
        _task = task;
        _identifier = [identifier copy];
    }
    return self;
}

- (CPFRunloopTask)task {
    NSAssert(_task != nil, @"CPFRunloopTaskUnit task 不能为空");
    return _task;
}

- (NSString *)identifier {
    NSAssert(_identifier != nil, @"CPFRunloopTaskUnit identifier 不能为空");
    return [_identifier copy];
}

@end

@interface CPFRunloopTaskManager ()
{
    @public
    CFRunLoopRef _runloop;
}

@property (nonatomic, strong) NSMutableArray <CPFRunloopTaskUnit *> *taskUnits;

@property (nonatomic, strong) CPFRunloopTaskUnit *currentExecuteTaskUnit;

@property (nonatomic, assign, getter=isSuspend) BOOL suspend;

@end

@implementation CPFRunloopTaskManager

- (void)addTaskUnit:(CPFRunloopTaskUnit *)taskUnit {
    [self.taskUnits addObject:taskUnit];
    if (self.taskUnits.count > _maximumTaskCount && self.taskUnits.count > 0) {
        [self.taskUnits removeObjectAtIndex:0];
    }
}

- (void)removeTaskUnit:(CPFRunloopTaskUnit *)taskUnit {
    [self removeTaskForIdentifier:taskUnit.identifier];
}

- (void)addTask:(CPFRunloopTask)task forIdentifier:(NSString *)identifier {
    CPFRunloopTaskUnit *taskUnit = [[CPFRunloopTaskUnit alloc] initTaskUnit:task forIdentifier:identifier];
    [self addTaskUnit:taskUnit];
}

- (void)removeTaskForIdentifier:(NSString *)identifier {
    [self.taskUnits enumerateObjectsUsingBlock:^(CPFRunloopTaskUnit * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![task isEqual:self.currentExecuteTaskUnit] && [task.identifier isEqualToString:identifier]) {
            [self.taskUnits removeObject:task];
        }
    }];
}

- (void)removeAllTaskUnit {
    [self.taskUnits enumerateObjectsUsingBlock:^(CPFRunloopTaskUnit * _Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![task isEqual:self.currentExecuteTaskUnit]) {
            [self.taskUnits removeObject:task];
        }
    }];
}

- (void)suspend {
    if (!self.isSuspend) {
        self.suspend = YES;
    }
}

- (void)resume {
    if (self.isSuspend) {
        self.suspend = NO;
    }
}

- (void)postRunloopPortMassgae:(NSData *)messageData {
    CFMessagePortRef remotePort = CFMessagePortCreateRemote(kCFAllocatorDefault, kRunloopPortSourceNotificationName);
    CFDataRef messageDataRef = CFBridgingRetain(messageData);
    CFMessagePortSendRequest(remotePort, kCFMessagePortSuccess, messageDataRef, 0, 10, kCFRunLoopDefaultMode, NULL);
}


- (void)registerRunloopForObserver:(CPFRunloopTaskManager *)instance {
    instance->_runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverContext context = { .version = 0, .info = (__bridge void *)instance, &CFRetain, &CFRelease, NULL };
    CFRunLoopObserverRef observer = CFRunLoopObserverCreate(kCFAllocatorDefault, kCFRunLoopBeforeWaiting, YES, 0, runLoopOberverCallback, &context);
    CFRunLoopAddObserver(instance->_runloop, observer, kCFRunLoopDefaultMode);
    
    // 添加Source1，用于监听端口通知
    CFMessagePortContext portContext = {.version = 0, .info = (__bridge void *)instance, &CFRetain, &CFRelease, NULL};
    CFMessagePortRef localPort = CFMessagePortCreateLocal(kCFAllocatorDefault, kRunloopPortSourceNotificationName, callBack, &portContext, NULL);
    CFRunLoopSourceRef source = CFMessagePortCreateRunLoopSource(kCFAllocatorDefault, localPort, 0);
    CFRunLoopAddSource(CFRunLoopGetCurrent(), source, kCFRunLoopDefaultMode);
    
    CFRelease(observer);
}

static inline void runLoopOberverCallback(CFRunLoopObserverRef observer, CFRunLoopActivity activity, void *info) {
    CPFRunloopTaskManager *instance = (__bridge CPFRunloopTaskManager *)info;
    if (instance.taskUnits.count == 0) {
        return;
    }
    BOOL result = NO;
    while (result == NO && instance.taskUnits.count && !instance.isSuspend) {
        CPFRunloopTaskUnit *taskUnit = instance.taskUnits.firstObject;
        instance.currentExecuteTaskUnit = taskUnit;
        result = taskUnit.task();
        if (result) {
            [instance.taskUnits removeObjectAtIndex:0];
        }
    }
    CFRunLoopWakeUp(instance->_runloop);
}

static inline CFDataRef callBack (CFMessagePortRef local, SInt32 msgid, CFDataRef data, void *info) {
    CPFRunloopTaskManager *Self = (__bridge CPFRunloopTaskManager *)info;
    NSData *messageData = (__bridge NSData *)data;
    if (Self.portMessageCallBack) {
        Self.portMessageCallBack(messageData);
    }
    return NULL;
}

+ (instancetype)defaultManager {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static CPFRunloopTaskManager *_sharedInstance;
    @synchronized(self) {
        if (_sharedInstance == nil) {
            _sharedInstance = [super allocWithZone:zone];
            
            _sharedInstance.maximumTaskCount = 10;
            _sharedInstance.taskUnits = [NSMutableArray array];
            _sharedInstance.currentExecuteTaskUnit = nil;
            _sharedInstance.suspend = NO;
            [_sharedInstance registerRunloopForObserver:_sharedInstance];
        }
    }
    return _sharedInstance;
}

@end
