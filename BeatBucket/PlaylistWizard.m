//
//  PlaylistWizard.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/20/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "PlaylistWizard.h"

@interface PlaylistWizard ()

@end

@implementation PlaylistWizard

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
    self.navigationItem.rightBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    self.selectedSongs = [[NSArray alloc] init];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // add cell for privacy if switch is on
    if(section == 0){
        return self.privacySwitch.on ? 3:2;
    }
    else{
        return 1;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction) privacyHandler {
    [self.tableView reloadData];
}

- (void) tableView: (UITableView *) tableView didSelectRowAtIndexPath: (NSIndexPath *) indexPath {
    
    if(indexPath.section == 1){
        [self performSegueWithIdentifier:@"SCSegue" sender:self];
    }
}

//called when sound cloud song view is closed
-(void)youViewController:(SCYouViewController *)YouViewController didChooseSongs:(NSMutableArray *)songs
{
    if([songs count] > 0)
        self.selectedSongs = songs;
    if ([self respondsToSelector:@selector(dismissModalViewControllerAnimated:)]) {
        [self performSelector:@selector(dismissModalViewControllerAnimated:) withObject:[NSNumber numberWithBool:YES]];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}
    

-(IBAction)doneHandler{
    // Create PFObject with recipe information
    PFObject *playlist = [PFObject objectWithClassName:@"Playlist"];
    [playlist setObject:self.nameInput.text forKey:@"name"];
    [playlist setObject:self.passwordInput.text forKey:@"password"];
    //[playlist setObject:[PFUser currentUser] forKey:@"owner"];
    [playlist setObject:self.selectedSongs forKey:@"songs"];
    [playlist setObject:[PFACL ACLWithUser:[PFUser currentUser]] forKey:@"ACL"];
    
    // Find first song in sound cloud with album art
    NSDictionary *track;
    int i = 0;
    do{
        track = [self.selectedSongs objectAtIndex:i++];
    }
        while([[track objectForKey:@"artwork_url"] isKindOfClass:[NSNull class]]);
        
    //if we found a non-null image
    if(![track isKindOfClass:[NSNull class]]){
    
        NSURL *imageURL = [NSURL URLWithString:[[track objectForKey:@"artwork_url"] stringByReplacingOccurrencesOfString:@"large" withString:@"badge"]];
        NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
        NSString *filename = [NSString stringWithFormat:@"%@.png", self.nameInput.text];
        PFFile *imageFile = [PFFile fileWithName:filename data:imageData];
        [playlist setObject:imageFile forKey:@"coverPic"];
    }
    
    // Show progress
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"Uploading";
    [hud show:YES];

    // Upload recipe to Parse
    [playlist saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [hud hide:YES];
        
        if (!error) {
            
            // Notify table view to reload the playlists from Parse cloud
            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshTable" object:self];
            
            // Dismiss the controller
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Upload Failure" message:[error localizedDescription] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    if([[segue identifier] isEqualToString:@"SCSegue"]){
        UITabBarController *tabController = segue.destinationViewController;
        UINavigationController *navController = tabController.viewControllers[0];
        SCYouViewController *youViewController = navController.viewControllers[0];
        youViewController.delegate = self;
    }
}

@end
