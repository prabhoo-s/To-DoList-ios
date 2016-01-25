//
//  DateConverter.m
//  TasksToDo
//
//  Created by Prabhu.S on 24/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "DateConverter.h"

#define kLocaleIdentifier @"en_US"

@implementation DateConverter

+ (NSString *)stringFromDate:(NSDate *)inDate withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:kLocaleIdentifier]];
    return [formatter stringFromDate:inDate];
}

+ (NSDate *)dateFromString:(NSString *)inDate withFormat:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:kLocaleIdentifier]];
    return [formatter dateFromString:inDate];
}

@end
