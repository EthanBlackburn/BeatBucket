//
//  SCSearchViewController.m
//  Queue
//
//  Created by Ethan on 1/26/14.
//  Copyright (c) 2014 Ethan. All rights reserved.
//

#import "SCSearchViewController.h"

@interface SCSearchViewController ()

@end

@implementation SCSearchViewController
@synthesize account;
@synthesize selectedSongs;
@synthesize songButtons;
@synthesize searchArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    account= [SCSoundCloud account];
    selectedSongs = [[NSMutableArray alloc] init];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addHandler:(id)sender
{
    UIButton *senderButton = (UIButton *)sender;
    NSDictionary *tempSong = [searchArray objectAtIndex:senderButton.tag];
    [selectedSongs addObject:tempSong];
    senderButton.enabled = NO;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    SCRequestResponseHandler searchHandler;
    searchHandler = ^(NSURLResponse *response, NSData *data, NSError *error) {
        NSError *jsonError = nil;
        NSJSONSerialization *jsonResponse = [NSJSONSerialization
                                             JSONObjectWithData:data
                                             options:0
                                             error:&jsonError];
        
        if (!jsonError && [jsonResponse isKindOfClass:[NSArray class]]) {
            searchArray = (NSArray *)jsonResponse;
            NSLog(@"%lu",(unsigned long)[searchArray count]);
        }
    };
    
    NSString *profileURL = [NSString stringWithFormat: @"http://api.soundcloud.com/tracks.json?{client_id={105963b586ee9e7633eef11e29ee5e20}&q={%@}&limit=20&streamable=true&order=playback_count",searchString];
    
    [SCRequest performMethod:SCRequestMethodGET
                  onResource:[NSURL URLWithString:profileURL]
             usingParameters:nil
                 withAccount:account
      sendingProgressHandler:nil
             responseHandler:searchHandler];
    
    return true;
    
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    
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
    return [searchArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Result";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:CellIdentifier];
    }
    for(UIView *view in cell.contentView.subviews){
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
    
    // Configure the cell...
    NSLog(@"%d",indexPath.row);
    UILabel *titleLabel;
    UILabel *artistLabel;
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(49.0, 5.0, 190.0, 25)];
    titleLabel.font = [UIFont systemFontOfSize:15.0];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.textColor = [UIColor blackColor];
    
    [cell.contentView addSubview:titleLabel];
    
    artistLabel = [[UILabel alloc] initWithFrame:CGRectMake(49.0, 25.0, 190.0, 20.0)];
    artistLabel.font = [UIFont systemFontOfSize:13.0];
    artistLabel.textAlignment = NSTextAlignmentLeft;
    artistLabel.textColor = [UIColor darkGrayColor];
    
    [cell.contentView addSubview:artistLabel];
    
    NSDictionary *track = (NSDictionary *)[searchArray objectAtIndex:indexPath.row];
    NSDictionary *user = [track objectForKey:@"user"];
    
    titleLabel.text = [track objectForKey:@"title"];
    artistLabel.text = [user objectForKey:@"username"];
    
    UIButton *addButton = (UIButton *)cell.accessoryView;
    [addButton addTarget:self action:@selector(addHandler:) forControlEvents:UIControlEventTouchUpInside];
    [addButton setTag:[indexPath row]];
    [songButtons addObject:addButton];
    [cell.contentView addSubview:addButton];
    
    UIImageView *albumView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0,3,47.0,47.0)];
    [cell.contentView addSubview:albumView];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if(![[track objectForKey:@"artwork_url"] isKindOfClass:[NSNull class]]){
            
            NSURL *imageURL = [NSURL URLWithString:[[track objectForKey:@"artwork_url"] stringByReplacingOccurrencesOfString:@"large" withString:@"badge"]];
            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
            UIImage *tempImage = [UIImage imageWithData:imageData];
            albumView.image = tempImage;
        }});
    return cell;

}


@end
