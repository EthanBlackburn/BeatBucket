//
//  beatbucketAppDelegate.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/16/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "beatbucketAppDelegate.h"
#import "ExploreController.h" //center
#import "LeftPanelTableViewController.h" //left
#import "NearbyController.h"
#import "MyPlaylistsController.h"
#import "NowPlayingController.h"
#import "ProfileController.h"
#import "FriendsController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Parse/Parse.h>
#import "SCUI.h"


@implementation beatbucketAppDelegate

+ (void) initialize
{
    [SCSoundCloud setClientID:@"259fbc74e78e72b60dd7b0efafa6467a"
                       secret:@"16acdc69892a9776ed42e4409079f194"
                  redirectURL:[NSURL URLWithString:@"BeatBucket://oauth"]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [[UINavigationBar appearance] setBarTintColor:UIColorFromRGB(0xff2835)];
    [[UINavigationBar appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:
                                                           [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0], NSForegroundColorAttributeName,nil]];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    //Parse SDK
    [Parse setApplicationId:@"cbhwLxBENAlgKgJGdNWklHhynfeX6Qsa4QrinumR"
                  clientKey:@"FFrO2dUl0tu8qaCt0o8hMldJtZr0GI1FFqkIWpqn"];
    //Parse statistics :P
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //facebook SDK
    [PFFacebookUtils initializeFacebook];

    
    // Override point for customization after application launch.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:[NSBundle mainBundle]];
    
    self.viewController = [[JASidePanelController alloc] init];
    self.viewController.shouldDelegateAutorotateToVisiblePanel = NO;
    LeftPanelTableViewController *leftPanel = [storyboard instantiateViewControllerWithIdentifier:@"leftViewController"];
	self.viewController.leftPanel = leftPanel;
    
    //add all view controllers to side bar
    [leftPanel setNearby:[storyboard instantiateViewControllerWithIdentifier:@"nearby"]];
    
    [leftPanel setFriends:[storyboard instantiateViewControllerWithIdentifier:@"friends"]];
    //add observer to check for friends every time we login
    [[NSNotificationCenter defaultCenter] addObserver:leftPanel.Friends
                                             selector:@selector(checkForFriends:)
                                                 name:@"login"
                                               object:nil];
    
    [leftPanel setExplore:[storyboard instantiateViewControllerWithIdentifier:@"centerViewController"]];//start with explore
    
    [leftPanel setMyPlaylists:[storyboard instantiateViewControllerWithIdentifier:@"playlists"]];
    
    [leftPanel setProfile:[storyboard instantiateViewControllerWithIdentifier:@"profile"]];
    
    [leftPanel setNowPlaying:[storyboard instantiateViewControllerWithIdentifier:@"playing"]];
    
	self.viewController.centerPanel = [[UINavigationController alloc] initWithRootViewController:[leftPanel Explore]];
    
	self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

//Next two are Parse methods.. Facebook login
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
