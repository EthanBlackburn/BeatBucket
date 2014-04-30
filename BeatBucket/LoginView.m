//
//  LoginView.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/19/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import "LoginView.h"

@interface LoginView ()

@end

@implementation LoginView

@synthesize activityIndicator = _activityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    // If you create your views manually, you MUST override this method and use it to create your views.
    // If you use Interface Builder to create your views, then you must NOT override this method.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)loginButtonTouchHandler  {
    // The permissions requested from the user
    NSArray *permissionsArray = @[ @"basic_info", @"user_location", @"email"];
    
    // Login PFUser using Facebook
    [PFFacebookUtils logInWithPermissions:permissionsArray block:^(PFUser *user, NSError *error) {
        [_activityIndicator stopAnimating]; // Hide loading indicator
        
        if (!user) {
            if (!error) {
                NSLog(@"Uh oh. The user cancelled the Facebook login.");
                [self.Delegate LoginViewController:self didExitSuccessfully:NO error:nil];
                
            } else {
                NSLog(@"Uh oh. An error occurred: %@", error);
                [self.Delegate LoginViewController:self didExitSuccessfully:NO error:error];
            }
        } else if (user.isNew) {
            NSLog(@"User with facebook signed up and logged in!");
            
            [self loggedIn];
    
        } else {
            NSLog(@"User with facebook logged in!");
            [self.Delegate LoginViewController:self didExitSuccessfully:YES error:nil];
            
        }
    }];

}

-(IBAction)cancelHandler{
    NSLog(@"Uh oh. The user cancelled the Facebook login.");
    [self.Delegate LoginViewController:self didExitSuccessfully:NO error:nil];
}


// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

-(void)loggedIn{
    NSString *requestPath = @"me/?fields=name,location,email,id";
    
    FBRequest *request = [[FBRequest alloc] initWithSession:[PFFacebookUtils session] graphPath:requestPath];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSDictionary *userData = (NSDictionary *)result; // The result is a dictionary
            
            [[PFUser currentUser] setObject:[userData objectForKey:@"name"] forKey:@"name"];
            
            [[PFUser currentUser] setObject:[userData objectForKey:@"email"] forKey:@"email"];
            
            [[PFUser currentUser] saveInBackground];
            
            
        }
    }];
    
    [self.Delegate LoginViewController:self didExitSuccessfully:YES error:nil];
}

@end
