//
//  LoginView.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/19/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol LoginViewControllerDelegate;

@interface LoginView : UIViewController

//delegate
@property (nonatomic, assign) id<LoginViewControllerDelegate> loginDelegate;

@property (strong, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)LoginViewController:(LoginView *)loginViewController
        didExitSuccessfully:(BOOL)status
                      error:(NSError *)error;
@end