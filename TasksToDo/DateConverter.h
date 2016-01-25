//
//  DateConverter.h
//  TasksToDo
//
//  Created by Prabhu.S on 24/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateConverter : NSObject

+ (NSString *)stringFromDate:(NSDate *)inDate withFormat:(NSString *)format;
+ (NSDate *)dateFromString:(NSString *)inDate withFormat:(NSString *)format;

@end
