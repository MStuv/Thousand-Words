//
//  TWAlbumTableViewController.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/2/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWAlbumTableViewController.h"
#import "Album.h"
#import "TWCoreDataHelper.h"
#import "TWPhotosCollectionViewController.h"

// conform to UIAlertViewDelegate in .m file makes the conform delegate private and not accessable from other classes
@interface TWAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation TWAlbumTableViewController

// lazy instantiation for albums mutableArray
-(NSMutableArray *)albums
{   // because of 1 line if statement, we can omit curly braces
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}



- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

// This method will be called each time that the view appears. (viewDidLoad is only called on the initial load of the view so it will not be called if the view is being returned to from another view)
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // NSFetchRequest object is used to get the entity from CoreData. Fetch the Entity named Album
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Album"];

    // once the fetch data begins, sortDescriptor will sort the fetched data by the date the objects were created using the date parameter.
    fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:YES]];
    
    // create an NSError instance
    NSError *error = nil;
    
    /* Create an array from the sorted fetched data using the executeFetchRequest: method of managedObjectContext, with an error object so that if an error occurs, it will be set to the NSError instance and we can view and debug any errors.
     
     • executeFetchRequest: is being called on the context object that is returned from the TWCoreDataHelper class method: managedObjectContext.
     
     • We created the TWCoreDataHelper class to refactor the reuse of creating a NSManagedObjectContext object and setting the value to the UIApplication sharedApplication delegate. */
    NSArray *fetchedAlbums = [[TWCoreDataHelper managedObjectContext]
                              executeFetchRequest:fetchRequest error:&error];
    
    // set the mutableArray albums equal to a mutableCopy of the fetchedAlbums array.
    self.albums = [fetchedAlbums mutableCopy];
    
    // reload the tableView data to reflect the data that was fetched.
    [self.tableView reloadData];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - IBAction Methods

- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    // instance of UIAlertView - with delegate: set to self.
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    // UIAlertView method that sets a alertViewStyle... in this case a plain textInput
    // This plain textInput will put a textField in the alertView to allow the user to enter text
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    // show alertView
    [newAlbumAlertView show];
}


#pragma mark - Helper Methods

/// Method called when creating a new Album instance
-(Album *)albumWithName:(NSString *)name
{
    /* Each NSManagedObject belongs to only one MSManagedObject Context - the context is responsible for managing the NSManagedObject.
     
     • context is being set to the returned value of the TWCoreDataHelper class method: managedObjectContext.
     
     • We created the TWCoreDataHelper class to refactor the reuse of creating a NSManagedObjectContext object and setting the value to the UIApplication sharedApplication delegate.
     */
    NSManagedObjectContext *context = [TWCoreDataHelper managedObjectContext];
    
    /* Create a new persistent Album object using the class method 'insertNewObjectForEntityForName'.
     - This is a class method on NSEntityDescription that takes bouth the entities name and a context (or scratchpad)
     - Entity Name is set the the Entity name created in the xcdatamodeld.*/
    Album *album = [NSEntityDescription insertNewObjectForEntityForName:@"Album" inManagedObjectContext:context];
    
    // with the NSManagedObject subclass, we can set its attributes exactly as we would properties.
    // set album.name to the name passed into the method
    album.name = name;
    // using the "date" method of NSDate, we are setting the date that the album was created.
    album.date = [NSDate date];
    
    // create an instance of NSError and if there is an error, save the error to the NSError instance so that it can be examined and debugged.
    NSError *error = nil;
    if (![context save:&error]) {
        //we have an error!
        NSLog(@"%@", error);
    }
    // return the created album
    return album;
}


#pragma mark - UIAlertView Delegate

// CLICK BUTTON AT INDEX Method - this delegate method is needed when 'otherButtonTitles:' is set to a string value. This will tell the alertView what to do when the other button is pressed
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // if the button pressed is buttonIndex 1...
    if (buttonIndex == 1) {
        // create an instance of NSString and set it to the text that was entered into the alertView
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        
        /// add to the albums array... the album that is returned from the albumWithName: Method
        [self.albums addObject: [self albumWithName:alertText]];
        
        /// insert the album object into the tableView row at the indexPath at the row that is 1 less the count of the albums array
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:[self.albums count]-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    // returning number of objects in the album array as the number of rows in tableView section
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    // Create instance of Album and set it to the album object at the indexPath's row of the albums array
    Album *selectedAlbum = self.albums[indexPath.row];
    // set cell textLabel to equal the name of the album object
    cell.textLabel.text = selectedAlbum.name;
    
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check to makes sure we are using the correct segue
    if ([segue.identifier isEqualToString:@"Album Chosen"]) {
        // Check to make sure that the distinationVC is of the correct class
        if  ([segue.destinationViewController isKindOfClass:[TWPhotosCollectionViewController class]]) {
            // create instance of NSIndexPath and set to the tableView method indexPathForSelectedRow
            NSIndexPath *path = [self.tableView indexPathForSelectedRow];
            // create instance of TWPhotosCollectionBV and set it equal to the segue.destinationVC
            TWPhotosCollectionViewController *targetViewController = segue.destinationViewController;
            // set the album property of the TWPhotoCollectionVC to equal the albums array at path.row
            targetViewController.album = self.albums[path.row];
        }
    }
}


@end
