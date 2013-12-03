//
//  Album.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/2/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "Album.h"


@implementation Album

/// dynamic tells compiler not to worry that the propery is not backed by an instance variable. At runtime the properties are directly accessed from the database.
@dynamic name;
@dynamic date;

@end
