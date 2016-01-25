//
//  PlistManager.h
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlistManager : NSObject

+ (PlistManager *)sharedPreferences;
+ (NSArray *)getAllTasks;
+ (void)addToMyPlist:(NSDictionary *)inDictionary;
+ (NSArray *)deleteTaskWithId:(NSString *)taskId;

@end
