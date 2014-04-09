//
//  TopPhotoListTableViewController.h
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoListTableViewController.h"

@interface TopPhotoListTableViewController : PhotoListTableViewController

@property (strong, nonatomic) NSMutableArray *sortingArray;
@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end
