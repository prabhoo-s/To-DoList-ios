//
//  TaskDetailViewController.h
//  TasksToDo
//
//  Created by Prabhu.S on 25/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TaskDetailViewController : UIViewController
@property (nonatomic, strong) NSArray *taskItems;
@property (nonatomic, assign) NSUInteger selecteTaskIndex;
@end
