//
//  PhotoListTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "PhotoListTableViewController.h"

@implementation PhotoListTableViewController

//-(void)setPhotos:(NSArray *)photos
//{
//    _photos = photos;
//    [self.tableView reloadData];
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotoList];
}

- (void)fetchPhotoList
{
    NSData *fetchData = [NSData dataWithContentsOfURL:self.URLForPhotoList];
    NSDictionary *fetchDictionary = [NSJSONSerialization JSONObjectWithData:fetchData options:0 error:NULL];
    self.photos = [fetchDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
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
    return [self.photos count];
}

@end
