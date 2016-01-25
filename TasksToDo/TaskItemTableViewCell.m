//
//  TaskItemTableViewCell.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "TaskItemTableViewCell.h"
#import "DateConverter.h"

#define kDateTimeFormat @"yyyy-MM-dd HH:mm"

#pragma mark - Implementation

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
        [DateConverter stringFromDate:[self.task valueForKey:@"createdDate"]
                           withFormat:kDateTimeFormat];
    self.createdDate.text = dateInString;
    self.categoryName.text = [self.task valueForKey:@"categoryName"];
    [self setImageView:[self.task valueForKey:@"priority"]];
}

- (void)setImageView:(NSString *)priority {
    if ([priority isEqualToString:@"High"]) {
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_red"]];
    }
    else if ([priority isEqualToString:@"Medium"]) {
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_yellow"]];
    }
    else if ([priority isEqualToString:@"Low"]) {
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_green"]];
    }
    else {
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_default"]];
    }
}

- (void)setPriorityImage:(TaskPriority)priority {
    switch (priority) {
      case High:
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_red"]];
        break;
      case Medium:
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_yellow"]];
        break;
      case Low:
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_green"]];
        break;
      default:
        [self.priorityIndicator setImage:[UIImage imageNamed: @"priority_default"]];
        break;
    }
}

@end

