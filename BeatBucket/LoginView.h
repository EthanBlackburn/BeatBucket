//
//  LoginView.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/19/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface LoginView : UIViewController <FBLoginViewDelegate>

// FB methods
@property (weak, nonatomic) IBOutlet FBLoginView *loginView;
@property (strong, nonatomic) IBOutlet FBProfilePictureView *profilePictureView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *statusLabel;

@end
