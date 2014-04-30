//
//  FriendsController.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface FriendsController : UITableViewController

@property (nonatomic) NSArray *fbFriends;
@property (nonatomic) NSArray *currentData; //set according to segmented control
@property (nonatomic) NSArray *users;
@property (nonatomic) NSMutableArray *notUsers;
@property (nonatomic) IBOutlet UISegmentedControl *segControl;

-(IBAction)segmentedControl;

-(void)checkForFriends:(NSNotification *) notification;


@end
