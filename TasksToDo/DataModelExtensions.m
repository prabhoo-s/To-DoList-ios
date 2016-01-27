//
//  DataModelExtensions.m
//  TasksToDo
//
//  Created by Prabhu.S on 26/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "DataModelExtensions.h"

@implementation Task(ModelExtensions)

TaskPriority priorityIntToEnum(NSInteger priority) {
    TaskPriority priorityType = Normal;
    switch (priority) {
      case 0:
        priorityType = High;
        break;
      case 1:
        priorityType = Medium;
        break;
      case 2:
        priorityType = Low;
        break;
      default:
        priorityType = Normal;
        break;
    }

    return priorityType;
}

NSInteger priorityEnumToInt(TaskPriority priority) {
    NSInteger returnValue = 3;

    switch (priority) {
      case High:
            returnValue = 0;
        break;
      case Medium:
            returnValue = 1;
        break;
      case Low:
            returnValue = 2;
        break;
      case Normal:
            returnValue = 3;
        break;
      default:
            returnValue = 3;
        break;
    }
    
    return returnValue;
}

NSString * priorityIntToString(NSInteger priority) {
    NSString *returnValue = @"Normal";
    switch (priority) {
      case 0:
        returnValue = @"High";
        break;
      case 1:
        returnValue = @"Medium";
        break;
      case 2:
        returnValue = @"Low";
        break;
      default:
        returnValue = @"Normal";
        break;
    }

    return returnValue;
}

TaskStatus statusIntToEnum(NSInteger status) {
    TaskStatus retutnStatus = Active;
    switch (status) {
      case 0:
        retutnStatus = Active;
        break;
      case 1:
        retutnStatus = Completed;
        break;
      default:
        retutnStatus = Active;
        break;
    }

    return retutnStatus;
}

@end