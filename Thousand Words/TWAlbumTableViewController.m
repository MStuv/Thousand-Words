//
//  TWAlbumTableViewController.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/2/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWAlbumTableViewController.h"

/// conform to UIAlertViewDelegate in .m file makes the conform delegate private and not accessable from other classes
@interface TWAlbumTableViewController () <UIAlertViewDelegate>

@end

@implementation TWAlbumTableViewController

/// lazy instantiation for albums mutableArray
-(NSMutableArray *)albums
{   /// because of 1 line if statement, we can omit curly braces
    if (!_albums) _albums = [[NSMutableArray alloc] init];
    return _albums;
}






- (IBAction)addAlbumBarButtonItemPressed:(UIBarButtonItem *)sender {
    
    /// instance of UIAlertView - with delegate: set to self.
    UIAlertView *newAlbumAlertView = [[UIAlertView alloc] initWithTitle:@"Enter New Album Name" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Add", nil];
    
    /// UIAlertView method that sets a alertViewStyle... in this case a plain textInput
    /// This plain textInput will put a textField in the alertView to allow the user to enter text
    [newAlbumAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    /// show alertView
    [newAlbumAlertView show];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIAlertView Delegate

/// CLICK BUTTON AT INDEX Method - this delegate method is needed when 'otherButtonTitles:' is set to a string value. This will tell the alertView what to do when the other button is pressed
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    /// if the button pressed is buttonIndex 1...
    if (buttonIndex == 1) {
        
        /// create an instance of NSString and set it to the text that was entered into the alertView
        NSString *alertText = [alertView textFieldAtIndex:0].text;
        
        NSLog(@"My new album is %@", alertText);
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
    /// returning number of objects in the album array as the number of rows in tableView section
    return [self.albums count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
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

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
