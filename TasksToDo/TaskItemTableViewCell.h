//
//  TaskItemTableViewCell.h
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Task.h"

#pragma mark - interface

@interface TaskItemTableViewCell : UITableViewCell

#pragma mark - Properties

@property (strong, nonatomic)Task *task;
@property (weak, nonatomic) IBOutlet UILabel *taskSubject;
@property (weak, nonatomic) IBOutlet UILabel *taskDescription;
@property (weak, nonatomic) IBOutlet UILabel *createdDate;
@property (weak, nonatomic) IBOutlet UILabel *categoryName;
@property (weak, nonatomic) IBOutlet UIImageView *priorityIndicator;
@property (weak, nonatomic) IBOutlet UIImageView *taskStatusImageView;

@end
