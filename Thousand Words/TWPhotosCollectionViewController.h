//
//  TWPhotosCollectionViewController.h
//  Thousand Words
//
//  Created by Mark Stuver on 12/3/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Album.h"

@interface TWPhotosCollectionViewController : UICollectionViewController


@property (strong, nonatomic) Album *album;


- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender;

@end
