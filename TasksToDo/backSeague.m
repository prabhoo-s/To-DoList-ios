//
//  backSeague.m
//  TasksToDo
//
//  Created by Prabhu.S on 25/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "backSeague.h"

@implementation backSeague

- (void)perform {
    UIViewController *svc = self.sourceViewController;
    [svc.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
