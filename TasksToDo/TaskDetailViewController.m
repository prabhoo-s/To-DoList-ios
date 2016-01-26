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
#import "PlistManager.h"

@interface TaskDetailViewController () <UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;
@property (nonatomic, assign) NSUInteger currentTaskIndex;

@end

@implementation TaskDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createPageViewController];
//    NSLog(@"selecteTaskIndex:%lu", (unsigned long)_selecteTaskIndex);
//    NSLog(@"selecteTaskIndex:%@", _taskItems);
    self.currentTaskIndex = self.selecteTaskIndex;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)createPageViewController {
    UIPageViewController *pageController =
        [self.storyboard instantiateViewControllerWithIdentifier:@"ID_PAGE_VC"];
    pageController.dataSource = self;
    pageController.delegate = self;
    
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

- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    if (completed) {
        self.currentTaskIndex =
            ((UIViewController *)self.pageViewController.viewControllers.firstObject).view.tag;
    }
}

#pragma mark - Private methods

- (AddTaskTableViewController *)itemControllerForIndex: (NSUInteger)itemIndex {
    if (itemIndex < [self.taskItems count]) {
        AddTaskTableViewController *pageItemController =
            [self.storyboard instantiateViewControllerWithIdentifier: @"ID_TASK_ITEM_VC"];
        pageItemController.itemIndex = itemIndex;
        
        NSDictionary *dict = [self.taskItems objectAtIndex:itemIndex];
        Task *myTask = [[Task alloc] initWithTaskID:dict[@"taskID"]
                                        taskSubject:dict[@"taskSubject"]
                                         taskDetail:dict[@"taskDetail"]
                                        createdDate:dict[@"createdDate"]
                                       reminderDate:dict[@"reminderDate"]
                                           priority:[[dict valueForKey:@"priority"] intValue]
                                       categoryName:dict[@"categoryName"]];
        pageItemController.taskItem = myTask;
        pageItemController.displayMode = ViewMode;
        pageItemController.view.tag = itemIndex;

        return pageItemController;
    }
    
    return nil;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SEGUE_PUSH_EDIT_TASK"]) {
        AddTaskTableViewController *vc = (AddTaskTableViewController *)[segue destinationViewController];
        NSDictionary *dict = [self.taskItems objectAtIndex:self.currentTaskIndex];
        Task *myTask = [[Task alloc] initWithTaskID:dict[@"taskID"]
                                        taskSubject:dict[@"taskSubject"]
                                         taskDetail:dict[@"taskDetail"]
                                        createdDate:dict[@"createdDate"]
                                       reminderDate:dict[@"reminderDate"]
                                           priority:[[dict valueForKey:@"priority"] intValue]
                                       categoryName:dict[@"categoryName"]];
        vc.taskItem = myTask;
        vc.displayMode = EditMode;
        [vc deleteTaskCallBack:^(NSString *taskString) {
            [PlistManager deleteTaskWithId:taskString];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate refreshTableView];
            }];
        }];
        [vc updateTaskCallBack:^(NSDictionary *task, NSString *taskString) {
            [PlistManager deleteTaskWithId:taskString];
            [PlistManager addToMyPlist:task];
            [self dismissViewControllerAnimated:YES completion:^{
                [self.delegate refreshTableView];
            }];
        }];
    }
}

@end
