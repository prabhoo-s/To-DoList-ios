//
//  PlistManager.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "PlistManager.h"

#define kTaskListFileName             @"MyTaskList.plist"
#define kTaskListFileExtension        @"plist"

@interface PlistManager ()

@end

@implementation PlistManager

#pragma mark - Init/Load

+ (PlistManager *)sharedPreferences {
    static PlistManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [PlistManager new];
    });

    return sharedManager;
}

- (id)init {
    self = [super init];
    
    if (self) {

    }

    return self;
}

#pragma mark - class methods

/* Code to write into file */

+ (void)addToMyPlist:(NSDictionary *)inDictionary {
    // set file manager object
    NSFileManager *manager = [NSFileManager defaultManager];

    NSString *plistPath = [PlistManager plistFilePath];
    // check if file exists

    BOOL isExist = [manager fileExistsAtPath:plistPath];

    NSMutableArray *plistArray = [NSMutableArray array];

    if (!isExist) {
        NSLog(@"MyTaskList.plist does not exist");
        [plistArray insertObject:inDictionary atIndex:0];
    }
    else {
        // get data from plist file
        plistArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];

        // insert dictionary

        [plistArray insertObject:inDictionary atIndex:[plistArray count]];
    }

    // write data to  plist file
    BOOL isWritten = [plistArray writeToFile:plistPath atomically:YES];

    plistArray = nil;

    // check for status
     NSLog(@" \n  written == %d",isWritten);
}

+ (NSString *)plistFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [[paths objectAtIndex:0] stringByAppendingPathComponent:kTaskListFileName];
}

#pragma mark - Task items

+ (NSArray *)getAllTasks {
    NSMutableArray *array = nil;

    NSString *plistPath = [PlistManager plistFilePath];
    // check if file exists

    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:plistPath];

    if (!isExist) {
        NSLog(@"%@ does not exist", kTaskListFileName);
    }
    else {
        // get data from plist file
        array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    }
    NSArray *sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"createdDate" ascending:NO]];
    return [array sortedArrayUsingDescriptors:sortDescriptors];
}

+ (NSArray *)deleteTaskWithId:(NSString *)taskId {
    NSMutableArray *array = nil;

    NSString *plistPath = [PlistManager plistFilePath];
    // check if file exists

    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:plistPath];

    if (!isExist) {
        NSLog(@"%@ does not exist", kTaskListFileName);
    }
    else {
        // get data from plist file
        array = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
        NSPredicate *predicate   = [NSPredicate predicateWithFormat:@"NOT (taskID like %@)", taskId];
        NSArray *filteredArray = [array filteredArrayUsingPredicate:predicate];
        
        // write data to  plist file
        BOOL isWritten = [filteredArray writeToFile:plistPath atomically:YES];
        filteredArray = nil;

        // check for status
        NSLog(@" \n  written == %d",isWritten);
    }
    
    return array;
}

@end

