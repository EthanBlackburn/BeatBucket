//
//  LeftPanelTableViewController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import "LeftPanelTableViewController.h"


@interface LeftPanelTableViewController ()


@end

@implementation LeftPanelTableViewController

@synthesize Nearby;
@synthesize Explore;
@synthesize Friends;
@synthesize Profile;
@synthesize NowPlaying;
@synthesize MyPlaylists;

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
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showNearby{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:Nearby]];
    
}

-(void)showProfile{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:Profile]];
    
}

-(void)showNowPlaying{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:NowPlaying]];
    
}

-(void)showMyPlaylists{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:MyPlaylists]];
}

-(void)showExplore{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:Explore]];
    
}
-(void)showFriends{
    [self.sidePanelController showCenterPanelAnimated:YES];
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:Friends]];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch([indexPath row]){
            case 0:
            [self showNowPlaying];
            break;
            
            case 1:
            [self showExplore];
            break;
            
            case 2:
            [self showNearby];
            break;
            
            case 3:
            [self showFriends];
            break;
            
            case 4:
            [self showMyPlaylists];
            break;
            
            case 5:
            [self showProfile];
            break;
    }
}


@end
