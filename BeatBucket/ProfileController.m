//
//  ProfileController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ProfileController.h"

@interface ProfileController ()

@end

@implementation ProfileController

@synthesize nameLabel = _nameLabel;
@synthesize imageData = _imageData;

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
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    // Create request for user's Facebook data
    FBRequest *request = [FBRequest requestForMe];
    
    // Send request to Facebook
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        // result is a dictionary with the user's Facebook data
        NSDictionary *userData = (NSDictionary *)result;
        
        NSString *facebookID = userData[@"id"];
        [self.nameLabel setText: userData[@"name"]];
        // Download the user's facebook profile picture
        self.imageData = [[NSMutableData alloc] init]; // the data will be loaded in here
        
        // URL should point to https://graph.facebook.com/{facebookId}/picture?type=large&return_ssl_resources=1
        NSURL *pictureURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large&return_ssl_resources=1", facebookID]];
        
        NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:pictureURL
                                                                  cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                              timeoutInterval:2.0f];
        // Run network request asynchronously
        NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    if(![PFUser currentUser]){
        // Create the log in view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginView *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [loginViewController setDelegate:self];
        
        // Present the log in view controller
        [self presentViewController:loginViewController animated:YES completion:NULL];
    }
    else{
        //if we are already logged in, get friends
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];
    }
}

-(void)LoginViewController:(LoginView *)loginViewController didExitSuccessfully:(BOOL)status error:(NSError *)error{
    NSLog(@"success!");
    [self dismissViewControllerAnimated:YES completion:nil];//dismiss login view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];//post friend notification

}

// Called every time a chunk of the data is received
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data]; // Build the image
    UIImage *image = [UIImage imageWithData:self.imageData];
    [self.userProfileImage setImage:image];
    //make image a circle
    self.userProfileImage.layer.cornerRadius = self.userProfileImage.frame.size.height /2;
    self.userProfileImage.layer.masksToBounds = YES;
    [self.userProfileImage.layer setBorderWidth: 0];
    
    //get Parse data(followers, following, playlists)
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    [query whereKeyExists:@"Followers"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d followers.", objects.count);
            //set label
            [self.followersLabel setText:[NSString stringWithFormat:@"%d",objects.count]];
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
            }
            [query whereKeyExists:@"Following"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                if (!error) {
                    // The find succeeded.
                    NSLog(@"Successfully retrieved %d following.", objects.count);
                    //set label
                    [self.followingLabel setText:[NSString stringWithFormat:@"%d",objects.count]];
                    // Do something with the found objects
                    for (PFObject *object in objects) {
                        NSLog(@"%@", object.objectId);
                    }
                    [query whereKeyExists:@"Playlists"];
                    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                        if (!error) {
                            // The find succeeded.
                            NSLog(@"Successfully retrieved %d playlists.", objects.count);
                            //set label
                            [self.playlistsLabel setText:[NSString stringWithFormat:@"%d",objects.count]];
                            // Do something with the found objects
                            for (PFObject *object in objects) {
                                NSLog(@"%@", object.objectId);
                            }
                        } else {
                            // Log details of the failure
                            NSLog(@"Error: %@ %@", error, [error userInfo]);
                        }
                    }];
                } else {
                    // Log details of the failure
                    NSLog(@"Error: %@ %@", error, [error userInfo]);
                }
            }];

        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}

// Called when the entire image is finished downloading
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // Set the image in the header imageView
    self.userProfileImage.image = [UIImage imageWithData:self.imageData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
