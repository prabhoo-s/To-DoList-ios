//
//  OrderedDictionary.m
//  TasksToDo
//
//  Created by Prabhu.S on 22/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "OrderedDictionary.h"

@interface OrderedDictionary() {
	NSMutableDictionary *dictionary;
	NSMutableArray *array;
}
- (NSUInteger)indexOfKey:(id)key;
- (NSEnumerator *)reverseKeyEnumerator;

@end

NSString *DescriptionForObject(NSObject *object, id locale, NSUInteger indent) {
	NSString *objectString;
	if ([object isKindOfClass:[NSString class]])
	{
		objectString = (NSString *)object;
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:indent:)])
	{
		objectString = [(NSDictionary *)object descriptionWithLocale:locale indent:indent];
	}
	else if ([object respondsToSelector:@selector(descriptionWithLocale:)])
	{
		objectString = [(NSSet *)object descriptionWithLocale:locale];
	}
	else
	{
		objectString = [object description];
	}
	return objectString;
}

@implementation OrderedDictionary

- (id)initWithCapacity:(NSUInteger)capacity {
	if (self = [super init]) {
		dictionary = [[NSMutableDictionary alloc] initWithCapacity:capacity];
		array = [[NSMutableArray alloc] initWithCapacity:capacity];
	}
	return self;
}


- (id)copy {
	return [self mutableCopy];
}


- (void)setObject:(id)anObject forKey:(id)aKey {
	if (![dictionary objectForKey:aKey]) {
		[array addObject:aKey];
	}
	[dictionary setObject:anObject forKey:aKey];
}


- (void)removeObjectForKey:(id)aKey {
	[dictionary removeObjectForKey:aKey];
	[array removeObject:aKey];
}


- (NSUInteger)count {
	return [dictionary count];
}


- (id)objectForKey:(id)aKey {
	return [dictionary objectForKey:aKey];
}


- (NSEnumerator *)keyEnumerator {
	return [array objectEnumerator];
}


- (NSEnumerator *)reverseKeyEnumerator {
	return [array reverseObjectEnumerator];
}


- (void)insertObject:(id)anObject forKey:(id)aKey atIndex:(NSUInteger)anIndex {
	if ([dictionary objectForKey:aKey]) {
		[self removeObjectForKey:aKey];
	}
	[array insertObject:aKey atIndex:anIndex];
	[dictionary setObject:anObject forKey:aKey];
}


- (id)keyAtIndex:(NSUInteger)anIndex {
	return [array objectAtIndex:anIndex];
}


- (NSUInteger)indexOfKey:(id)key {
    return [array indexOfObject:key];
}


- (NSString *)descriptionWithLocale:(id)locale indent:(NSUInteger)level {
	NSMutableString *indentString = [NSMutableString string];
	NSUInteger i, count = level;
	for (i = 0; i < count; i++)
	{
		[indentString appendFormat:@"    "];
	}
	
	NSMutableString *description = [NSMutableString string];
	[description appendFormat:@"%@{\n", indentString];
	for (NSObject *key in self)
	{
		[description appendFormat:@"%@    %@ = %@;\n",
			indentString,
			DescriptionForObject(key, locale, level),
			DescriptionForObject([self objectForKey:key], locale, level)];
	}
	[description appendFormat:@"%@}\n", indentString];
	return description;
}

@end
