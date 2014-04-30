//
//  MyPlaylistsController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "MyPlaylistsController.h"

@interface MyPlaylistsController ()

@end

@implementation MyPlaylistsController

@synthesize playlists;

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
    //add color to nav bar buttons
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    [self.view setBackgroundColor: UIColorFromRGB(0x555555)];
    playlists = [[NSMutableArray alloc] init];
    
    PFQuery *playlistQuery = [PFQuery queryWithClassName:@"Playlist"];
    [playlistQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %lu playlists.", (unsigned long)objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            [playlists addObjectsFromArray:objects];
            [self.tableView reloadData];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlaylistCell" forIndexPath:indexPath];
    
    // Configure the cell...
    cell.backgroundColor = UIColorFromRGB(0x555555); //background for cell
    
    UILabel *titleLabel;
    UILabel *songsLabel;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 10.0, 190.0, 25)];
    titleLabel.font = [UIFont systemFontOfSize:17.5];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor whiteColor];
    
    [cell.contentView addSubview:titleLabel];
    [titleLabel setText:[[playlists objectAtIndex:indexPath.row] objectForKey:@"name"]];
    
    songsLabel = [[UILabel alloc] initWithFrame:CGRectMake(65.0, 35.0, 190.0, 20.0)];
    songsLabel.font = [UIFont systemFontOfSize:15.0];
    songsLabel.textAlignment = NSTextAlignmentLeft;
    songsLabel.textColor = [UIColor lightGrayColor];
    
    [cell.contentView addSubview:songsLabel];
    int songCount = [[[playlists objectAtIndex:indexPath.row] objectForKey:@"songs"] count];
    NSString *pluralize = songCount > 1 ? @"songs":@"song"; //pluralize string count
    [songsLabel setText:[NSString stringWithFormat:@"%d %@",songCount,pluralize]];
    
    UIImageView *albumView = [[UIImageView alloc] initWithFrame:CGRectMake(10.0,7.5,47.0,47.0)];
    [cell.contentView addSubview:albumView];
    
    PFFile *userImageFile = playlists[indexPath.row][@"coverPic"];
    [userImageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:imageData];
            albumView.image = image;
        }
    }];
    
    //cell separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.tag = 4;
    
    [cell.contentView addSubview:lineView];
    
    lineView.backgroundColor = UIColorFromRGB(0x7f7f7f);
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [playlists count];
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
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

//called after user releases selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0xff2835);
}

//separator line color return to normal after deselect
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0x7f7f7f);
}

//need this method to color separator line during highlight
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0xff2835);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //cell selection
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = UIColorFromRGB(0x2b2b2b);
    cell.selectedBackgroundView = selectionColor;
}

- (void)wizardViewController:(PlaylistWizard *)YouViewController didChooseSongs:(BOOL)empty{
    //add condition for empty songs
    if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES]];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    //refresh
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"wizardSegue"]){
        UINavigationController *navController = segue.destinationViewController;
        PlaylistWizard *wizard = navController.viewControllers[0];
        wizard.delegate = self;
    }
}



@end
