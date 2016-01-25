//
//  OrderedDictionary.h
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - interface

@interface OrderedDictionary : NSMutableDictionary 

- (id)keyAtIndex:(NSUInteger)anIndex;
- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex;

@end
