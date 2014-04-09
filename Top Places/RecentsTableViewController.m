//
//  RecentsTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-3-27.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "RecentsTableViewController.h"
#import "FlickrFetcher.h"
#import "ImageViewController.h"
#import "RecentsDatabase.h"

@interface RecentsTableViewController ()

@end

@implementation RecentsTableViewController

- (NSArray *)sortingArray
{
    if (!_sortingArray) {
        _sortingArray = [[NSMutableArray alloc] initWithCapacity:10];
    }
    return _sortingArray;
}

- (NSDictionary *)dictionary
{
    if (!_dictionary) {
        _dictionary = [[NSDictionary alloc] init];
    }
    return _dictionary;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [self readDatabase];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self readDatabase];
}

- (void)readDatabase
{
    RecentsDatabase *recentsDatabase = (RecentsDatabase *)[RecentsDatabase standardUserDefaults];
    self.sortingArray = [recentsDatabase arrayForKey:@"array"];
    self.dictionary = [recentsDatabase dictionaryForKey:@"dictionary"];
    [self.tableView reloadData];    // 性能问题，需要改
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning 用国家名区别section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sortingArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Recents Photo" forIndexPath:indexPath];

    cell.textLabel.text = self.sortingArray[indexPath.row];
    
    if (cell.textLabel.text.length == 0) {      // 如果没有titile，就改成Unknown
        cell.textLabel.text = @"Unknown";
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        if (indexPath) {
            if ([segue.identifier isEqualToString:@"showPhoto"]) {
                if ([segue.destinationViewController isKindOfClass:[ImageViewController class]]) {
                    [self segueAndDisplayPhotos:segue.destinationViewController photoTitle:self.sortingArray[indexPath.row]];
                }
            }
        }
    }
}

- (void)segueAndDisplayPhotos:(ImageViewController *)ivc photoTitle:(NSString *)photoTitle
{
    NSData *urlData = (NSData *)[self.dictionary objectForKey:photoTitle];
    UIImage *image = [UIImage imageWithData:urlData];
//    NSURL *url = [NSURL URLWithString:string];
//    ivc.URLForImage = url;
    ivc.title = photoTitle;
    ivc.image = image;
}

@end
