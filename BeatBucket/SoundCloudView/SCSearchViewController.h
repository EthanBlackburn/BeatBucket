//
//  SCSearchViewController.h
//  Queue
//
//  Created by Ethan on 1/26/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCUI.h"

@interface SCSearchViewController : UIViewController <UISearchBarDelegate, UISearchDisplayDelegate, UITableViewDelegate, UITableViewDataSource>

@property IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSArray *searchArray;
@property (nonatomic) NSMutableArray *selectedSongs;
@property (assign) SCAccount *account;
@property (nonatomic) NSMutableArray *songButtons;

@end
