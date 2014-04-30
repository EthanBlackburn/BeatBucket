//
//  ExploreController.m
//  BeatBucket
//
//  Created by Ethan Blackburn on 4/17/14.
//  Copyright (c) 2014 Ethan Blackburn. All rights reserved.
//
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#import "ExploreController.h"


@interface ExploreController ()

@end

@implementation ExploreController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view setBackgroundColor: UIColorFromRGB(0x555555)];
    self.navigationItem.leftBarButtonItem.tintColor = UIColorFromRGB(0xf7f7f7);
    /*if (!([PFUser currentUser] && // Check if a user is cached
        [PFFacebookUtils isLinkedWithUser:[PFUser currentUser]])) // Check if user is linked to Facebook
    {
        LoginView *fbLogin = [[LoginView alloc] init];
        fbLogin.loginDelegate = self;
        if ([self respondsToSelector:@selector(presentViewController:animated:completion:)]){
            [self presentViewController:fbLogin animated:YES completion:nil];
        } else {
            [self presentModalViewController:fbLogin animated:YES];
        
        }
    }*/
    if(![PFUser currentUser]){
        // Create the log in view controller
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        LoginView *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"login"];
        [loginViewController setDelegate:self];
        
        // Present the log in view controller
        [self presentViewController:loginViewController animated:YES completion:NULL];
    }
    else{
        //if we are already logged in, get friends
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)LoginViewController:(LoginView *)loginViewController didExitSuccessfully:(BOOL)status error:(NSError *)error{
    NSLog(@"success!");
    [self dismissViewControllerAnimated:YES completion:nil];//dismiss login view
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:self];//post friend notification
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ExploreCell" forIndexPath:indexPath];
    
    
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

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    //cell background
    [cell setBackgroundColor:UIColorFromRGB(0x404040)];
    
    //cell selection
    UIView *selectionColor = [[UIView alloc] init];
    selectionColor.backgroundColor = UIColorFromRGB(0xff7e61);
    cell.selectedBackgroundView = selectionColor;
    
    //cell separator
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, cell.contentView.frame.size.height - 1.0, cell.contentView.frame.size.width, 1)];
    
    [cell.contentView addSubview:lineView];
    
    CAGradientLayer *selectedGrad1 = [CAGradientLayer layer];
    selectedGrad1.frame = lineView.bounds;
    selectedGrad1.colors = [NSArray arrayWithObjects:(id)[UIColorFromRGB(0xff5e3a) CGColor], (id)[UIColorFromRGB(0xff2a68) CGColor], nil];
    [selectedGrad1 setStartPoint:CGPointMake(0.0, 0.5)];
    [selectedGrad1 setEndPoint:CGPointMake(1.0, 0.5)];
    
    [lineView.layer insertSublayer:selectedGrad1 atIndex:0];
}

@end
