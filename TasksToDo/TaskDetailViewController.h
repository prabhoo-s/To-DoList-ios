//
//  TaskDetailViewController.h
//  TasksToDo
//
//  Created by Prabhu.S on 25/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - protocol

@protocol ReloadTableViewOnTaskDeletion <NSObject>
- (void)refreshTableView;
@end

@interface TaskDetailViewController : UIViewController

#pragma mark - Properties

@property (weak, nonatomic) id<ReloadTableViewOnTaskDeletion> delegate;
@property (nonatomic, strong) NSArray *taskItems;
@property (nonatomic, assign) NSUInteger selecteTaskIndex;

@end
