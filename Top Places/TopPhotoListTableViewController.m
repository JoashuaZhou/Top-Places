//
//  TopPhotoListTableViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "TopPhotoListTableViewController.h"
#import "ImageViewController.h"
#import "RecentsDatabase.h"

@interface TopPhotoListTableViewController ()

@end

@implementation TopPhotoListTableViewController

- (NSMutableArray *)sortingArray
{
    if (!_sortingArray) {
        RecentsDatabase *recentsDatabase = (RecentsDatabase *)[RecentsDatabase standardUserDefaults];
        _sortingArray = [[NSMutableArray alloc] initWithArray:[recentsDatabase arrayForKey:@"array"]];
    }
    return _sortingArray;
}

- (NSMutableDictionary *)dictionary
{
    if (!_dictionary) {
        RecentsDatabase *recentsDatabase = (RecentsDatabase *)[RecentsDatabase standardUserDefaults];
        _dictionary = [[NSMutableDictionary alloc] initWithDictionary:[recentsDatabase dictionaryForKey:@"dictionary"]];
    }
    return _dictionary;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TopPlaces Photo" forIndexPath:indexPath];
    
    NSDictionary *photo = self.photos[indexPath.row];
    cell.textLabel.text = [photo valueForKeyPath:FLICKR_PHOTO_TITLE];
    if (cell.textLabel.text.length == 0) {      // 如果没有titile，就改成Unknown
        cell.textLabel.text = @"Unknown";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    id detail = self.splitViewController.viewControllers[1];
    if ([detail isKindOfClass:[UINavigationController class]]) {        // 因为不这样做，detail就会变成navigationController而不是ImageViewController
        detail = ((UINavigationController *)detail).viewControllers.firstObject;
    }
    if ([detail isKindOfClass:[ImageViewController class]]) {
        [self segueAndDisplayPhotos:detail photo:self.photos[indexPath.row]];
    }
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
    
    // saveDatabase是个intensive job，为了不阻塞main queue，我们新创建一个线程来做这件事
    dispatch_queue_t databaseThread = dispatch_queue_create("databaseThread", NULL);
    dispatch_async(databaseThread, ^{ [self saveDatabase:tpvc.title andURL:tpvc.URLForImage]; });
}

- (void)saveDatabase:(NSString *)title andURL:(NSURL *)url
{
//    [self readDatabase];
    RecentsDatabase *recentsDatabase = (RecentsDatabase *)[RecentsDatabase standardUserDefaults];
    NSData *urlData = [NSData dataWithContentsOfURL:url];   // ContentOfURL存的是URL的内容，这里即URL对应的图片，而不是URL本身
    [self.dictionary setObject:urlData forKey:title];        // 有个漏洞，就是dictionary不断增大
//    NSLog(@"%@",[self.dictionary objectForKey:title]);
    [recentsDatabase setObject:self.dictionary forKey:@"dictionary"];
    if ([self.sortingArray count] == 10) {
        for (NSString *photoTitle in self.sortingArray) {
            if (photoTitle == title) {
                [self.sortingArray removeObject:photoTitle];
                [self.sortingArray addObject:photoTitle];
                [recentsDatabase setObject:self.sortingArray forKey:@"array"];
                return;
            }
        }
        [self.sortingArray removeObjectAtIndex:0];
    }
    [self.sortingArray addObject:title];
    [recentsDatabase setObject:self.sortingArray forKey:@"array"];
//    [recentsDatabase synchronize]; // 马上把cache中的数据写入磁盘
}

//- (void)readDatabase      不知道为什么这么写是不行的，所以想要每次读取database，我把它放在init数组和字典里面了
//{
//    NSUserDefaults *recentsDatabase = [NSUserDefaults standardUserDefaults];
//    self.sortingArray = (NSMutableArray *)[recentsDatabase arrayForKey:@"array"];
//    self.dictionary = (NSMutableDictionary *)[recentsDatabase dictionaryForKey:@"dictionary"];
//}


@end
