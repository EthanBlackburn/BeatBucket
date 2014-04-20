//
//  ProfileController.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <QuartzCore/QuartzCore.h>
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface ProfileController : UIViewController <NSURLConnectionDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *userProfileImage;
@property (nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic) IBOutlet UILabel *followersLabel;
@property (nonatomic) IBOutlet UILabel *followingLabel;
@property (nonatomic) IBOutlet UILabel *playlistsLabel;
@property (nonatomic) NSMutableDictionary *followers;
@property (nonatomic) NSMutableDictionary *following;
@property (nonatomic) NSMutableDictionary *fplaylists;
@property (nonatomic) NSMutableData *imageData;


@end
