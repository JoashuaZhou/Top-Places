//
//  TopPhotoListTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "TopPhotoListTableViewController.h"
#import "ImageViewController.h"

@interface TopPhotoListTableViewController ()

@end

@implementation TopPhotoListTableViewController

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopPlaces Photo" forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"showPhoto"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self segueAndDisplayPhotos:segue.destinationViewController photo:self.photos[indexPath.row]];
                }
            }
        }
    }
}

- (void)segueAndDisplayPhotos:(ImageViewController *)tpvc photo:(NSDictionary *)photos
{
    tpvc.URLForImage = [FlickrFetcher URLforPhoto:photos format:FlickrPhotoFormatLarge];
    tpvc.title = [photos valueForKeyPath:FLICKR_PHOTO_TITLE];
}

@end
