//
//  TopPlacesTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-3-27.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "TopPlacesTableViewController.h"
#import "FlickrFetcher.h"
#import "TopPhotoListTableViewController.h"

@interface TopPlacesTableViewController ()

@end

@implementation TopPlacesTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchTopPlacesList];
}

- (void)fetchTopPlacesList
{
    NSURL *fetchURL = [FlickrFetcher URLforTopPlaces];
    NSData *fetchData = [NSData dataWithContentsOfURL:fetchURL];
    NSDictionary *fetchDictionary = [NSJSONSerialization JSONObjectWithData:fetchData options:0 error:NULL];
    self.fetchPlaces = [fetchDictionary valueForKeyPath:FLICKR_RESULTS_PLACES];
//    self.fetchPlacesID = [fetchDictionary valueForKeyPath:FLICKR_PLACE_ID]; 这样肯定获取不到PlaceID，因为上一行获得的是一大堆Place类
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
    return [self.fetchPlaces count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopPlaces Photo List" forIndexPath:indexPath];
    NSDictionary *places = self.fetchPlaces[indexPath.row];
    
    NSString *placeInformation = [places valueForKeyPath:FLICKR_PLACE_NAME]; // 与FLICKR_PHOTO_TITLE区别？与valueForKeyPath区别？
    NSArray *title = [placeInformation componentsSeparatedByString:@", "];
    cell.textLabel.text = title[0];
    if ([title count] > 2) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@, %@", title[1], title[2]];
    }else
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", title[1]];
    cell.detailTextLabel.textColor = [UIColor blueColor];
  
    return cell;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"showPhotoList"]) {
                if ([segue.destinationViewController isKindOfClass:[PhotoListTableViewController class]]) {
                    [self showPhotolist:segue.destinationViewController fromPlace:self.fetchPlaces[indexPath.row]];
                }
            }
        }
    }
}

- (void)showPhotolist:(PhotoListTableViewController *)pvc fromPlace:(NSDictionary *)placeDictionary
{
    id placeID = [placeDictionary valueForKeyPath:FLICKR_PLACE_ID]; // 要获取placeID要像这样获取，与获取名字方式一样
    pvc.URLForPhotoList = [FlickrFetcher URLforPhotosInPlace:placeID maxResults:50];
    NSString *placeInformation = [placeDictionary valueForKeyPath:FLICKR_PLACE_NAME];
    NSArray *title = [placeInformation componentsSeparatedByString:@", "];
    pvc.title = title[0];
}
@end
