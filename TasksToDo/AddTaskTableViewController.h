//
//  AddTaskTableViewController.h
//  TasksToDo
//
//  Created by Prabhu.S on 24/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

typedef enum : NSUInteger {
    EditMode = 0,
    ViewMode,
} ViewControllerDisplayMode;

typedef void (^newTaskCallBack)(NSDictionary *task);
typedef void (^deleteTaskCallBack)(NSString *taskString);
typedef void (^updateTaskCallBack)(NSDictionary *task, NSString *taskString);

@interface AddTaskTableViewController : UITableViewController  

#pragma mark - Properties

@property (strong, nonatomic)Task *taskItem;
@property (nonatomic, copy) NSString *textViewContent;
@property (nonatomic , assign) ViewControllerDisplayMode displayMode;

#pragma mark - Callback Method

- (void)newTaskCallBack:(newTaskCallBack)callback;
- (void)deleteTaskCallBack:(deleteTaskCallBack)callback;
- (void)updateTaskCallBack:(updateTaskCallBack)callback;

#pragma mark - Item controller information
@property (nonatomic) NSUInteger itemIndex;

@end
