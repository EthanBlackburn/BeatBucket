//
//  PlaylistWizard.h
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/20/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"
#import "SCYouViewController.h"

@protocol playlistWizardDelegate;

@interface PlaylistWizard : UITableViewController <UITextFieldDelegate, SCYouViewControllerDelegate>

@property (nonatomic) id<playlistWizardDelegate> delegate;
@property (nonatomic) IBOutlet UISwitch *privacySwitch;
@property (nonatomic) IBOutlet UITextField *nameInput;
@property (nonatomic) IBOutlet UITextField *passwordInput;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (nonatomic) IBOutlet UIButton *cancelButton;
@property (nonatomic) NSArray *selectedSongs;

-(IBAction) privacyHandler;
-(IBAction) doneHandler;
-(IBAction) cancelHandler;

@end

@protocol playlistWizardDelegate<NSObject>

- (void)wizardViewController:(PlaylistWizard *)YouViewController
           didChooseSongs:(BOOL)empty;
@end