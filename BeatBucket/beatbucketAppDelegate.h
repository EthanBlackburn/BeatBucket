//
//  beatbucketAppDelegate.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/16/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JASidePanelController.h"
#import "UIViewController+JASidePanel.h"

@interface beatbucketAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController *viewController;

@end
