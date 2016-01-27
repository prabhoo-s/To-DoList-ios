//
//  Task.h
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Task : NSObject

@property (nonatomic, copy) NSString *taskID;
@property (nonatomic, copy) NSString *taskSubject;
@property (nonatomic, copy) NSString *taskDetail;
@property (nonatomic, retain) NSDate *createdDate;
@property (nonatomic, retain) NSDate *reminderDate;
@property (nonatomic, assign) NSInteger priority;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, copy) NSString *categoryName;

- (id)initWithTaskID:(NSString *)taskID
        taskSubject:(NSString *)taskSubject
        taskDetail:(NSString *)taskDetail
         createdDate:(NSDate *)createdDate
        reminderDate:(NSDate *)reminderDate
        priority:(NSInteger)priority
        status:(NSInteger)status
        categoryName:(NSString *)categoryName;
@end
