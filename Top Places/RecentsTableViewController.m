//
//  RecentsTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-3-27.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchRecentsList];
}

- (void)fetchRecentsList
{
    NSURL *fetchURL = [FlickrFetcher URLforRecentGeoreferencedPhotos];
    NSData *fetchData = [NSData dataWithContentsOfURL:fetchURL];
    NSDictionary *fetchDictionary = [NSJSONSerialization JSONObjectWithData:fetchData options:0 error:NULL];
    self.fetchRecents = [fetchDictionary valueForKeyPath:FLICKR_RESULTS_PLACES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.fetchRecents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recents Photo" forIndexPath:indexPath];
    NSDictionary *recents = self.fetchRecents[indexPath.row];
    
    NSString *recentsInformation = [recents valueForKeyPath:FLICKR_PLACE_NAME]; // 与FLICKR_PHOTO_TITLE区别？与valueForKeyPath区别？
    NSArray *title = [recentsInformation componentsSeparatedByString:@", "];
    cell.textLabel.text = title[0];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", title[1], title[2]];
    cell.detailTextLabel.textColor = [UIColor blueColor];
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

@end
