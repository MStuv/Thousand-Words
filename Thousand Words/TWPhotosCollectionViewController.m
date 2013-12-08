//
//  TWPhotosCollectionViewController.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/3/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWPhotosCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"
#import "TWPictureDataTransformer.h"
#import "TWCoreDataHelper.h"
#import "TWPhotoDetailViewController.h"

// Privately... Conform to ImagePickerVC & NavigationC Delegates
@interface TWPhotosCollectionViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSMutableArray *photos; ///of UIImages

@end

@implementation TWPhotosCollectionViewController

/// lazy instantiation of photos array
-(NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [[NSMutableArray alloc] init];
    }
    return _photos;
}

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
    
    // create an instance of NSSet (an unordered set of objects and can not include duplicate obects)
    // the saved photos in CoreData are saved as NSSet objects
    NSSet *unorderedPhotos = self.album.photos;
    
    // create an instance of NSSortDescriptor and set to sort the key 'date' and set ascending to YES
    NSSortDescriptor *dateDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES];
    
    // create can instance of NSArray and load with the unorderedPhotos objects sorted using the dateDescriptor.
    NSArray *sortedPhotos = [unorderedPhotos sortedArrayUsingDescriptors:@[dateDescriptor]];
    
    // set the mutable array equal to a mutableCopy of the sortedPhotos array.
    self.photos = [sortedPhotos mutableCopy];
    
    // Refresh collectionView
    [self.collectionView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // make sure we have the correct identifier
    if ([segue.identifier isEqualToString:@"Detail Segue"]) {
        
        NSLog(@"%@", segue.identifier);
        
        // make sure we have the correct destinationVC by checking the class of the destinationVC
        if ([segue.destinationViewController isKindOfClass:[TWPhotoDetailViewController class]]) {
            
            NSLog(@"%@", [segue.destinationViewController class]);
            
            // create an instance of TWPhotoDetailVC and set it's value to the destinationVC
            TWPhotoDetailViewController *targetVC = segue.destinationViewController;
            // create an instance of NSIndexPath and set it's value to the collectionView's method indexPathsForSelectedItems - at the last Object.
            NSIndexPath *indexPath = [[self.collectionView indexPathsForSelectedItems] lastObject];
            // create instance of Photo and set to the object at the indexPath.row of the photos array
            Photo *selectedPhoto = self.photos[indexPath.row];
            // set the selectedPhoto property from the destinationVC to the currentVC's photo property. w
            targetVC.photo = selectedPhoto;
        }
    }
}


- (IBAction)cameraBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    // Intialize an instance of UIImagePickerController
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // set picker's delegate to the currentVC
    picker.delegate = self;
    
    // if the camera is available, set sourceType to camera
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    // if camera is not available, set sourceType to savedPhotosAlbum
    else if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    }
    // present the imagePickerViewController
    [self presentViewController:picker animated:YES completion:nil];
}


#pragma mark - Helper Methods

// method will take a UIImage and Return a Photo instance
-(Photo *)photoFromImage:(UIImage *)image
{
    // Create instance of Photo and set to the CoreData ManagedObject *see TWAlbumTableViewController.m/albumWithName: method
    Photo *photo = [NSEntityDescription insertNewObjectForEntityForName:@"Photo" inManagedObjectContext:[TWCoreDataHelper managedObjectContext]];
    
    // set Photo instance's image property to the UIImage passed to this method
    photo.image = image;
    // set Photo instance's date property to the current date
    photo.date = [NSDate date];
    // set Photo instance's albumBook property
    photo.albumBook = self.album;
    
    // Create instance of NSError and set to nil
    NSError *error = nil;
    // if there is a problem, save the error to the NSError instance so that it can be looked at and debugged.
    if (![[photo managedObjectContext] save:&error]) {
        // Error in saving
        NSLog(@"%@", error);
    }
    return photo;
}


#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the CellIdentifier
    static NSString *CellIdentifier = @"Photo Cell";
    
    // Create instance of TWPhotoCollectionViewCell and set it to as the dequeueReusableCell at the indexPath
    TWPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Create instance of Photo and set to the object in photos array at indexPath.row
    Photo *photo = self.photos[indexPath.row];
    
    // set color of cell's background to white
    cell.backgroundColor = [UIColor whiteColor];
    
    // set cell imageView's image to image property of photo instance
    cell.imageView.image = photo.image;
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // return count of mutableArray
    return [self.photos count];
}


#pragma mark - UIImagePickerController Delegate

// DID FINISH PICKING
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Set UIImage instance to the ImagePicker Edited Image
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
     // if the image is nil (no edited Image)... use originalImage
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    // addObject to mutableArray via the helper method 'photoFromImage:' passing the image instance.
    [self.photos addObject:[self photoFromImage:image]];
    
    // reload collectionView
    [self.collectionView reloadData];
    
    // dismissVC
    [self dismissViewControllerAnimated:YES completion:nil];
}

// DID CANCEL PICKER
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
