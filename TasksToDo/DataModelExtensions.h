//
//  DataModelExtensions.h
//  TasksToDo
//
//  Created by Prabhu.S on 26/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Task.h"

typedef NS_ENUM(NSInteger, TaskPriority) {
    High,
    Medium,
    Low,
    Normal,
};

@interface Task(ModelExtensions)

TaskPriority priorityIntToEnum(NSInteger priority);
NSInteger priorityEnumToInt(TaskPriority priority);
NSString * priorityIntToString(NSInteger priority);

@end
