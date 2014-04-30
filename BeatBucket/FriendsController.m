//
//  FriendsController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "FriendsController.h"

@interface FriendsController ()

@end

@implementation FriendsController

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
    self.tableView.backgroundColor = UIColorFromRGB(0x555555);
    
    self.users = [[NSMutableArray alloc] init];
    self.notUsers = [[NSMutableArray alloc] init];
    self.currentData = self.users; //just to initialize
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    NSLog(@"friends %d",self.fbFriends.count);
    NSLog(@"users %d",self.users.count);
    NSLog(@"not users %d",self.notUsers.count);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//switch active data according to segmented control
-(IBAction)segmentedControl{
    if(self.segControl.selectedSegmentIndex == 0){
        self.currentData = self.users;
    }
    else{
        self.currentData = self.notUsers;
    }
    [self.tableView reloadData];
}

-(void)checkForFriends:(NSNotification *) notification{
    NSLog(@"fetching friends..");
    if([[notification name] isEqualToString:@"login"]){
        
        // Issue a Facebook Graph API request to get your user's friend list
        [FBRequestConnection startForMyFriendsWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result will contain an array with your user's friends in the "data" key
                self.fbFriends = [result objectForKey:@"data"];
                NSMutableArray *friendIds = [NSMutableArray arrayWithCapacity:self.fbFriends.count];
                // Create a list of friends' Facebook IDs
                for (NSDictionary *friendObject in self.fbFriends) {
                    [friendIds addObject:[friendObject objectForKey:@"id"]];
                    
                }
                
                // Construct a PFUser query that will find friends whose facebook ids
                // are contained in the current user's friend list.
                PFQuery *friendQuery = [PFUser query];
                [friendQuery whereKey:@"fbId" containedIn:friendIds];
                
                // findObjects will return a list of PFUsers that are friends
                // with the current user
                self.users = [friendQuery findObjects];
            }
        }];
        
        //difference between self.fbfriends and self.users
        [self.notUsers addObjectsFromArray:self.fbFriends];
        [self.notUsers removeObjectsInArray:self.users];
        
        if(self.segControl.selectedSegmentIndex == 0){
            self.currentData = self.users;
        }
        else{
            self.currentData = self.notUsers;
        }
        [self.tableView reloadData];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return self.currentData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendCell" forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"FriendCell"];
    }
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
  
    NSDictionary *friend = [self.fbFriends objectAtIndex:indexPath.row];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10.0, 7.5, 230.0, 20)];
    nameLabel.font = [UIFont systemFontOfSize:20.0];
    nameLabel.textAlignment = NSTextAlignmentLeft;
    nameLabel.textColor = [UIColor whiteColor];
    [cell.contentView addSubview:nameLabel];
    [nameLabel setText: friend[@"name"]];
    
    //cell separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    lineView.tag = 4;
    
    [cell.contentView addSubview:lineView];
    
    lineView.backgroundColor = UIColorFromRGB(0x7f7f7f);
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

//called after user releases selection
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0xff2835);
}

//separator line color return to normal after deselect
-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0x7f7f7f);
}

//need this method to color separator line during highlight
-(void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIView *separatorLine = (UIView *)[cell viewWithTag:4];
    separatorLine.backgroundColor = UIColorFromRGB(0xff2835);
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //cell selection
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = UIColorFromRGB(0x2b2b2b);
    cell.selectedBackgroundView = selectionColor;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
