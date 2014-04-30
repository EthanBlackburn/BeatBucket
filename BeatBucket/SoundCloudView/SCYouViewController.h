//
//  SCYouViewController.h
//  Queue
//
//  Created by Ethan on 1/26/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <OAuth2Client/NXOAuth2.h>
#import "SCUI.h"

@protocol SCYouViewControllerDelegate;

@interface SCYouViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>


@property (nonatomic) id<SCYouViewControllerDelegate> delegate;
@property (nonatomic) IBOutlet UIImageView *profilePicture;
@property (nonatomic) IBOutlet UILabel *profileName;
@property (nonatomic) NSDictionary *profile;
@property (nonatomic) IBOutlet UISegmentedControl *segmentButtons;
@property (nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) NSArray *tracks;
@property (nonatomic) NSArray *playlists;
@property (nonatomic) NSArray *posts;
@property (nonatomic) NSArray *currentData;
@property (nonatomic) SCAccount *account;
@property (nonatomic) NSMutableArray *selectedSongs;
@property (nonatomic) NSMutableArray *songButtons;

-(IBAction)addHandler:(id)sender;
-(IBAction)segmentedControl:(id)sender;

@end

@protocol SCYouViewControllerDelegate <NSObject>

- (void)youViewController:(SCYouViewController *)YouViewController
               didChooseSongs:(NSMutableArray *)songs;
@end