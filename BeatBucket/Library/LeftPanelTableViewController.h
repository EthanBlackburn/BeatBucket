//
//  LeftPanelTableViewController.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SidePanelControllerViewController.h"
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"
#import "ExploreController.h"
#import "NearbyController.h"
#import "ProfileController.h"
#import "FriendsController.h"
#import "NowPlayingController.h"
#import "MyPlaylistsController.h"

@interface LeftPanelTableViewController : UITableViewController

@property (nonatomic) ExploreController *Explore;
@property (nonatomic) NearbyController *Nearby;
@property (nonatomic) ProfileController *Profile;
@property (nonatomic) FriendsController *Friends;
@property (nonatomic) NowPlayingController *NowPlaying;
@property (nonatomic) MyPlaylistsController *MyPlaylists;

@end
