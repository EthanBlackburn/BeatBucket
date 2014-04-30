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
@property (nonatomic, assign) id<LoginViewControllerDelegate> Delegate;
@property (nonatomic) IBOutlet UIButton *exitBtn;
@property (nonatomic) IBOutlet UIButton *fbLogin;
@property (nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)loginButtonTouchHandler;
-(IBAction)cancelHandler;

@end

@protocol LoginViewControllerDelegate <NSObject>

- (void)LoginViewController:(LoginView *)loginViewController
        didExitSuccessfully:(BOOL)status
                      error:(NSError *)error;
@end