//
//  Task.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "Task.h"

@implementation Task

- (id)initWithTaskID:(NSString *)taskID
         taskSubject:(NSString *)taskSubject
          taskDetail:(NSString *)taskDetail
         createdDate:(NSDate *)createdDate
        reminderDate:(NSDate *)reminderDate
            priority:(NSInteger)priority
              status:(NSInteger)status
        categoryName:(NSString *)categoryName {

    if (self = [super init]) {
        _taskID = [taskID copy];
        _taskSubject = [taskSubject copy];
        _taskDetail = [taskDetail copy];
        _createdDate = createdDate;
        _reminderDate = reminderDate;
        _taskDetail = [taskDetail copy];
        _priority = priority;
        _status = status;
        _categoryName = [categoryName copy];
    }
 
    return self;
}

@end
