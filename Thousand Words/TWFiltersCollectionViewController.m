//
//  TWFiltersCollectionViewController.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/7/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWFiltersCollectionViewController.h"
#import "TWPhotoCollectionViewCell.h"
#import "Photo.h"

@interface TWFiltersCollectionViewController ()

/// Private Property for this class only
@property (strong, nonatomic) NSMutableArray *filters;
@property (strong, nonatomic) CIContext *context;

@end

@implementation TWFiltersCollectionViewController

/// lazy instantiations
-(NSMutableArray *)filters
{
    if(!_filters) _filters = [[NSMutableArray alloc] init];
    return _filters;
}

-(CIContext *)context
{
    if (!_context) _context = [CIContext contextWithOptions:nil];
    return _context;
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
    
    /// Load mutableArray filters with a mutableCopy of the array that is returned from the photoFilters class method
    self.filters = [[[self class] photoFilters] mutableCopy];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Helper Methods

/// This is made as a Class Method to give future flexability to use in other controllers
+(NSArray *)photoFilters
{
    CIFilter *sepia = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:nil];
    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:nil];
    CIFilter *colorClamp = [CIFilter filterWithName:@"CIColorClamp" keysAndValues:@"inputMaxComponents", [CIVector vectorWithX:0.9 Y:0.9 Z:0.9 W:0.9], @"inputMinComponents", [CIVector vectorWithX:0.2 Y:0.2 Z:0.2 W:0.2], nil];
    CIFilter *instant = [CIFilter filterWithName:@"CIPhotoEffectInstant" keysAndValues:nil];
    CIFilter *noir = [CIFilter filterWithName:@"CIPhotoEffectNoir" keysAndValues:nil];
    CIFilter *vignette = [CIFilter filterWithName:@"CIVignetteEffect" keysAndValues:nil];
    CIFilter *colorControls = [CIFilter filterWithName:@"CIColorControls" keysAndValues:kCIInputSaturationKey, @0.5, nil];
    CIFilter *transfer = [CIFilter filterWithName:@"CIPhotoEffectTransfer" keysAndValues:nil];
    CIFilter *unsharpen = [CIFilter filterWithName:@"CIUnsharpMask" keysAndValues:nil];
    CIFilter *monochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:nil];
    
    NSArray *allFilters = @[sepia, blur, colorClamp, instant, noir, vignette, colorControls, transfer, unsharpen, monochrome];
    
    return allFilters;
}

/// Method That Applies the passed filter to the passed image
-(UIImage *)filteredImageFromImage:(UIImage *)image andFilter:(CIFilter *)filter
{
    /// Convert UIImage to an instance of CIImage
    CIImage *unfilteredImage = [[CIImage alloc] initWithCGImage:image.CGImage];
    
    /// set up filter
    [filter setValue:unfilteredImage forKey:kCIInputImageKey];
    
    /// apply filter to image using the CIImage method outputImage and set to value of instance of CIImage
    CIImage *filteredImage = [filter outputImage];
    
    /// create an instance of CGRect and set it to the size of the image
    CGRect extent = [filteredImage extent];
    
    /// convert the CIImage to a CGImageRef
    CGImageRef cgImage = [self.context createCGImage:filteredImage fromRect:extent];
    
    /// convert CGImage to an instance of UIImage
    UIImage *finalImage = [UIImage imageWithCGImage:cgImage];
    
    /// return UIImage instance with final filter
    return finalImage;
}

#pragma mark - UICollectionView DataSource

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Photo Cell";
    
    TWPhotoCollectionViewCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    /// WE ARE APPLYING THE FILTER TO THE IMAGE USING A BLOCK - ON ANOTHER THREAD
    /// Created a queue and used a function to create a name (this is a C Function so no @ for
    dispatch_queue_t filterQueue = dispatch_queue_create("filter queue", NULL);
    /// Push the queue onto another thread with a block
    dispatch_async(filterQueue, ^{
        UIImage *filterImage = [self filteredImageFromImage:self.photo.image andFilter:self.filters[indexPath.row]];
        
        /// WE ARE ASSIGNING THE FILTERED IMAGE TO THE CELL's IMAGEVIEW USING A BLOCK - BACK ON THE MAIN THREAD
        /** We now push the change of the cell.imageView.image back to the main thread and set the image.
         (      We do this because we have to do all UI changes on the main thread) */
        dispatch_async(dispatch_get_main_queue(), ^{
            cell.imageView.image = filterImage;
        });
    });
    
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.filters count];
}


#pragma mark - UICollectionView Delegate

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    /// What cell did the user select
    TWPhotoCollectionViewCell *selectedCell = (TWPhotoCollectionViewCell *) [collectionView cellForItemAtIndexPath:indexPath];
    
    self.photo.image = selectedCell.imageView.image;
    
    /// TO FIX BUG THAT ALLOWS USER TO SELECT A COLLECTIONCELL BEFORE THE FILTER LOADS - GIVING THE USER A BLANK PHOTO THAT ALSO SAVES THE BLANK TO COREDATA
    
    /// Create an if statement to comfirm the the photo has an image before saving to CoreData
    if (self.photo.image) {
        
        NSError *error = nil;
        
        if (![[self.photo managedObjectContext] save:&error]) {
            NSLog(@"%@", error);
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}


@end
