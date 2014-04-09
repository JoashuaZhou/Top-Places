//
//  PhotoListTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "PhotoListTableViewController.h"

@implementation PhotoListTableViewController

-(void)setPhotos:(NSArray *)photos  // 用于下拉刷新时，reloadData
{
    _photos = photos;
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchPhotoList];
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

- (void)fetchPhotoList
{
    [self.refreshControl beginRefreshing];  // 下拉刷新
    dispatch_queue_t fetchQ = dispatch_queue_create("flickr fetcher", NULL);
    dispatch_async(fetchQ, ^{
        NSData *fetchData = [NSData dataWithContentsOfURL:self.URLForPhotoList];
        NSDictionary *fetchDictionary = [NSJSONSerialization JSONObjectWithData:fetchData options:0 error:NULL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.refreshControl endRefreshing];
            self.photos = [fetchDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];
        });
    });

//        NSData *fetchData = [NSData dataWithContentsOfURL:self.URLForPhotoList];
//        NSDictionary *fetchDictionary = [NSJSONSerialization JSONObjectWithData:fetchData options:0 error:NULL];
//        [self.refreshControl endRefreshing];
//        self.photos = [fetchDictionary valueForKeyPath:FLICKR_RESULTS_PHOTOS];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

@end
