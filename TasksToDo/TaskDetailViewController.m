//
//  TaskDetailViewController.m
//  TasksToDo
//
//  Created by Prabhu.S on 25/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "TaskDetailViewController.h"
#import "AddTaskTableViewController.h"
#import "Task.h"

@interface TaskDetailViewController ()<UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPageViewController];
//    NSLog(@"selecteTaskIndex:%lu", (unsigned long)_selecteTaskIndex);
//    NSLog(@"selecteTaskIndex:%@", _taskItems);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createPageViewController {
    UIPageViewController *pageController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ID_PAGE_VC"];
    pageController.dataSource = self;
    
    if ([self.taskItems count]) {
        NSArray *startingViewControllers = @[[self itemControllerForIndex: self.selecteTaskIndex]];
        [pageController setViewControllers: startingViewControllers
                                 direction: UIPageViewControllerNavigationDirectionForward
                                  animated: NO
                                completion: nil];
    }
    
    self.pageViewController = pageController;
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerBeforeViewController:(UIViewController *) viewController {
    AddTaskTableViewController *itemController = (AddTaskTableViewController *) viewController;
    
    if (itemController.itemIndex > 0) {
        return [self itemControllerForIndex: itemController.itemIndex - 1];
    }
    
    return nil;
}

- (UIViewController *) pageViewController: (UIPageViewController *) pageViewController viewControllerAfterViewController:(UIViewController *) viewController {
    AddTaskTableViewController *itemController = (AddTaskTableViewController *) viewController;
    
    if (itemController.itemIndex + 1 < [self.taskItems count]) {
        return [self itemControllerForIndex: itemController.itemIndex + 1];
    }
    
    return nil;
}

#pragma mark - Private methods

- (AddTaskTableViewController *)itemControllerForIndex: (NSUInteger)itemIndex {
    if (itemIndex < [self.taskItems count]) {
        AddTaskTableViewController *pageItemController =
            [self.storyboard instantiateViewControllerWithIdentifier: @"ID_TASK_ITEM_VC"];
        pageItemController.itemIndex = itemIndex;
        
        NSDictionary *dict = [self.taskItems objectAtIndex:itemIndex];
        Task *myTask = [[Task alloc] initWithTaskID:dict[@"taskID"] taskSubject:dict[@"taskSubject"] taskDetail:dict[@"taskDetail"] createdDate:dict[@"createdDate"] reminderDate:dict[@"reminderDate"] priority:dict[@"priority"] categoryName:dict[@"categoryName"]];
        pageItemController.taskItem = myTask;
        return pageItemController;
    }
    
    return nil;
}

@end
