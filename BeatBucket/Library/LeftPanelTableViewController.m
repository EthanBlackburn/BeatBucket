//
//  LeftPanelTableViewController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

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
    self.view.backgroundColor = UIColorFromRGB(0x2b2b2b);
    
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

-(void) logout{
    [PFUser logOut]; //logout
    [self.sidePanelController showCenterPanelAnimated:YES];
    //explore tab presents login view
    [self.sidePanelController setCenterPanel:[[UINavigationController alloc] initWithRootViewController:Explore]];

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
            
            case 6:
            [self logout];
            break;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:UIColorFromRGB(0x2b2b2b)];
    /*CAGradientLayer *selectedGrad = [CAGradientLayer layer];
    selectedGrad.frame = cell.bounds;
    selectedGrad.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xff5e3a) CGColor], (id)[UIColorFromRGB(0xff2a68) CGColor], nil];
    
    [cell setSelectedBackgroundView:[[UIView alloc] init]];
    [cell.selectedBackgroundView.layer insertSublayer:selectedGrad atIndex:0];*/
    
    //cell selection
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = UIColorFromRGB(0xff2835);
    cell.selectedBackgroundView = selectionColor;
    
}




@end
