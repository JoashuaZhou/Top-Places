//
//  PhotoListTableViewController.h
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FlickrFetcher.h"

@interface PhotoListTableViewController : UITableViewController

@property (strong, nonatomic) NSURL *URLForPhotoList;
@property (strong, nonatomic) NSArray *photos;

@end
