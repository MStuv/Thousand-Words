//
//  TWPhotoDetailViewController.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/7/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWPhotoDetailViewController.h"
#import "Photo.h"
#import "TWFiltersCollectionViewController.h"

@interface TWPhotoDetailViewController ()

@end

@implementation TWPhotoDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.imageView.image = self.photo.image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    /// if correct segue identifier
    if ([segue.identifier isEqualToString:@"Filter Segue"]) {
        
        /// if correct destinationVC class
        if ([segue.destinationViewController isKindOfClass:[TWFiltersCollectionViewController class]]) {
            
            /// create instance of TWFilterCollectionVC and set value to segue.destinationVC
            TWFiltersCollectionViewController *targetVC = segue.destinationViewController;
            
            /// set destinationVC's photo property equal to currentVC's photo property
            targetVC.photo = self.photo;
        }
    }
}



- (IBAction)addFiliterButtonPressed:(UIButton *)sender {
    
    
    
}

- (IBAction)deleteButtonPressed:(UIButton *)sender {
    
    [[self.photo managedObjectContext] deleteObject:self.photo];
    
    // WHEN USING SIMULATOR: for CoreData to save the deleted image and we must include the following code that saves to CoreData
    
    // WHEN ON DEVICE: the following is not needed if the code is running on a device. CoreData will auto save that the photo is deleted. The following code is only needed when using the simulator.
    NSError *error = nil;
    [[self.photo managedObjectContext] save:&error];
    if (error) {
        NSLog(@"error");
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
