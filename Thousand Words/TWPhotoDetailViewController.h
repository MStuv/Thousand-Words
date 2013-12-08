//
//  TWPhotoDetailViewController.h
//  Thousand Words
//
//  Created by Mark Stuver on 12/7/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import <UIKit/UIKit.h>

/// Class Forward Declaration??
@class Photo;

@interface TWPhotoDetailViewController : UIViewController

@property (strong, nonatomic) Photo *photo;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;


- (IBAction)addFiliterButtonPressed:(UIButton *)sender;
- (IBAction)deleteButtonPressed:(UIButton *)sender;
@end
