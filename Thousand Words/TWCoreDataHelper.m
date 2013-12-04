//
//  TWCoreDataHelper.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/3/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWCoreDataHelper.h"

@implementation TWCoreDataHelper

+(NSManagedObjectContext *)managedObjectContext
{
    /// Create a NSManagedObjectContext instance and sit its value to blank
    NSManagedObjectContext *context = nil;
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    /// test to make sure that the delegate variable exsists
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        
        /// set context to the delegate
        context = [delegate managedObjectContext];
    }
    
    return context;
}

@end
