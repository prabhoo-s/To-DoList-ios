//
//  TaskItemTableViewCell.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "TaskItemTableViewCell.h"
#import "DateConverter.h"
#import "DataModelExtensions.h"

#define kDateTimeFormat @"MMM dd yyyy hh:mm a"

#pragma mark - Implementation

@interface TaskItemTableViewCell()
- (UIImage *)getPriorityImage:(TaskPriority)priority;
- (UIImage *)getStatusImage:(TaskStatus)status;
@end

@implementation TaskItemTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTask:(Task *)task {
    _task = task;
    
    [self updateView];
}

- (void)updateView {
    self.taskSubject.text = [self.task valueForKey:@"taskSubject"];
    self.taskDescription.text = [self.task valueForKey:@"taskDetail"];
    NSString *dateInString =
        [DateConverter stringFromDate:[self.task valueForKey:@"reminderDate"]
                           withFormat:kDateTimeFormat];
    self.createdDate.text = dateInString;
    self.categoryName.text = [self.task valueForKey:@"categoryName"];
    TaskPriority tPriority = priorityIntToEnum([[self.task valueForKey:@"priority"] intValue]);
    [self.priorityIndicator setImage:[self getPriorityImage:tPriority]];
    TaskStatus status = statusIntToEnum([[self.task valueForKey:@"status"] intValue]);
    [self.taskStatusImageView setImage:[self getStatusImage:status]];
}

- (UIImage *)getPriorityImage:(TaskPriority)priority {
    UIImage *returnImage = [UIImage imageNamed: @"priority_default"];
    
    switch (priority) {
      case High:
        returnImage = [UIImage imageNamed: @"priority_red"];
        break;
      case Medium:
        returnImage = [UIImage imageNamed: @"priority_yellow"];
        break;
      case Low:
        returnImage = [UIImage imageNamed: @"priority_green"];
        break;
      default:
        returnImage = [UIImage imageNamed: @"priority_default"];
        break;
    }
    
    return returnImage;
}

- (UIImage *)getStatusImage:(TaskStatus)status {
    UIImage *returnImage = [UIImage new];
    switch (status) {
      case Active:
        returnImage = returnImage;
        break;
      case Completed:
        returnImage = [UIImage imageNamed: @"complete"];
        break;
      default:
        returnImage = returnImage;
        break;
    }
    
    return returnImage;
}

@end

