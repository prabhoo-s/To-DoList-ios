//
//  TaskListTableViewController.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "TaskListTableViewController.h"
#import "PlistManager.h"
#import "OrderedDictionary.h"
#import "Task.h"
#import "TaskItemTableViewCell.h"
#import "AddTaskTableViewController.h"
#import "TaskDetailViewController.h"

#define kDateFormat @"dd MM yyyy"

#pragma mark - Private Interface

@interface TaskListTableViewController () <ReloadTableViewOnTaskDeletion>

#pragma mark - Private Properties

@property (strong, nonatomic) OrderedDictionary *dateWiseTaskList;
@end

#pragma mark - Implementation

@implementation TaskListTableViewController

#pragma mark - UIViewController overrides

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareDaySeparatedList];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return [self.dateWiseTaskList count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSArray *sortedNotes =
        [self.dateWiseTaskList objectForKey:[self.dateWiseTaskList keyAtIndex:section]];
    return sortedNotes.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *lblSectionHeader = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    lblSectionHeader.backgroundColor = [UIColor lightGrayColor];
    
    lblSectionHeader.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:11];
    lblSectionHeader.textColor = [UIColor whiteColor];
    
    // Text to display
    
    NSDate *taskDate = [self.dateWiseTaskList keyAtIndex:section];
    
    // Check if it's today's date
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *components =
        [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay)
               fromDate:[NSDate date]];
    NSDate *today = [cal dateFromComponents:components];
    
    // Check if it's yesterday's date
    components =
        [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay)
               fromDate:[[NSDate date] dateByAddingTimeInterval:-(3600*24)]];
    NSDate *yesterday = [cal dateFromComponents:components];
    
    components =
        [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:taskDate];
    taskDate = [cal dateFromComponents:components];
    
    NSString *strDate = nil;
    if([today isEqualToDate:taskDate]) {
        strDate = @"TODAY";
    }
    else if([yesterday isEqualToDate:taskDate]) {
        strDate = @"YESTERDAY";
    }
    else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMM yyyy"];
        strDate = [[dateFormatter stringFromDate:taskDate] uppercaseString];
    }
    
    // Display text
    lblSectionHeader.text =[@"    " stringByAppendingString:strDate];
    
    return lblSectionHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"tasks.list.cell";
    TaskItemTableViewCell *cell =
        (TaskItemTableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSArray *sortedTasks = [self.dateWiseTaskList objectForKey:[self.dateWiseTaskList keyAtIndex:indexPath.section]];
    cell.task = [sortedTasks objectAtIndex:indexPath.row];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return true;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSArray *sortedTasks = [self.dateWiseTaskList objectForKey:[self.dateWiseTaskList keyAtIndex:indexPath.section]];
        NSDictionary *task = [sortedTasks objectAtIndex:indexPath.row];
        [PlistManager deleteTaskWithId:[task valueForKey:@"taskID"]];
        [self prepareDaySeparatedList];
        [self.tableView reloadData];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SEGUE_PUSH_VIEW_TASK"]) {
        UINavigationController *navController = [segue destinationViewController];
        TaskDetailViewController *tdViewController = (TaskDetailViewController *)([navController viewControllers][0]);
        tdViewController.taskItems = [PlistManager getAllTasks];
        NSLog(@"self.dateWiseTaskList:%@", self.dateWiseTaskList);
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        tdViewController.selecteTaskIndex = path.row;
        tdViewController.taskItems = [PlistManager getAllTasks];
        tdViewController.delegate = self;
    }
    else if ([segue.identifier isEqualToString:@"SEGUE_PUSH_ADD_TASK"]) {
        AddTaskTableViewController *vc = (AddTaskTableViewController *)[segue destinationViewController];
        __weak TaskListTableViewController  *weakself = self;
        vc.displayMode = CreateMode;
        [vc newTaskCallBack:^(NSDictionary *task) {
            [PlistManager addToMyPlist:task];
            [weakself prepareDaySeparatedList];
        }];
    }
}

#pragma mark - Sort tasks

- (void)prepareDaySeparatedList {
    self.dateWiseTaskList = [[OrderedDictionary alloc] initWithCapacity:0];
    
    NSArray *tasks = [PlistManager getAllTasks];
    
    if (tasks.count < 1) {
        [self.tableView reloadData];
        return;
    }
    
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];
    tasks = [tasks sortedArrayUsingDescriptors:sortDescriptors];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat:kDateFormat];
    [tasks enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        Task *task  = (Task *)obj;
        
        NSDate *date =
            [dateFormatter dateFromString:[dateFormatter stringFromDate:[task valueForKey:@"createdDate"]]];
        
        NSMutableArray *tempList = [self.dateWiseTaskList objectForKey:date];
        if (!tempList) {
            tempList = [[NSMutableArray alloc] init];
            [self.dateWiseTaskList setObject:tempList forKey:date];
        }
        [tempList addObject:task];
    }];
    
    [self.tableView reloadData];
}

- (void)refreshTableView {
    [self prepareDaySeparatedList];
}

@end
