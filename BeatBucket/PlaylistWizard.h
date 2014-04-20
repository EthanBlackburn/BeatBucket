//
//  PlaylistWizard.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/20/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistWizard : UITableViewController

@property (nonatomic) IBOutlet UISwitch *privacySwitch;
@property (nonatomic) IBOutlet UITextField *nameInput;
@property (nonatomic) IBOutlet UIButton *nextButton;
@property (nonatomic) IBOutlet UIButton *cancelButton;

-(IBAction) privacyHandler;

@end
