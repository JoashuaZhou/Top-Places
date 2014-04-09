//
//  ImageViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ImageViewController.h"
#import "TopPlacesTableViewController.h"

@interface ImageViewController () <UIScrollViewDelegate, UISplitViewControllerDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.scrollView addSubview:self.imageView];
    [self.navigationItem.backBarButtonItem setTitle:@""];
}

// Lazy instaniation
- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

#pragma mark - setter & getter

- (UIImage *)image
{
    return self.imageView.image;
}

- (void)setURLForImage:(NSURL *)URLForImage
{
    _URLForImage = URLForImage;
    [self downloadPhoto];   // 每次改变URL都会重新下载图片
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    _scrollView = scrollView;
    
    // 要实现scrollView的zoom功能，就要设置以下3个参数
    _scrollView.minimumZoomScale = 0.5;
    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;    // 这里设置自己为delegate，要声明<UIScrollViewDelegate>协议
    
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
}

- (void)setImage:(UIImage *)image
{
    self.imageView.image = image;
    
    self.scrollView.zoomScale = 1.0;
    self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.width);
    self.scrollView.contentSize = self.image ? self.image.size : CGSizeZero;
    [self.spinner stopAnimating];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageView;
}

- (void)downloadPhoto
{
    self.image = nil;   // 每次下载时，原图片要清空
    
    // 注意：要在storyboard里面的菊花选项的Animating去掉，不然就算你不选图片，菊花也会出现
    [self.spinner startAnimating];  // 如果把这一句放在self.image = nil前面，就看不到菊花了，为什么？
    NSURLRequest *request = [NSURLRequest requestWithURL:self.URLForImage];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration ephemeralSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDownloadTask *task = [session downloadTaskWithRequest:request
                                                    completionHandler:^(NSURL *localfile, NSURLResponse *response, NSError *error){
                                                        if (!error) {
                                                            if ([request.URL isEqual:self.URLForImage]) {     // 这里防止下载到一半时，用户切换到table的另一个cell，导致request要下载的图片改变了
                                                                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:localfile]];  // 这里其实localfile是一个从URL下载下来的临时文件
                                                                dispatch_async(dispatch_get_main_queue(), ^{ self.image = image; });
                                                            }
                                                        }
                                                    }];

    [task resume];  // 默认是挂起
}

#pragma mark - iPad support
- (void)awakeFromNib
{
    self.splitViewController.delegate = self;   // 因为UISplitViewController没有设置类，所以把delegate设置成self，这self这里帮它实现那些方法
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation  // 其实这方法是default，就算不设置也是这样
{
    return UIInterfaceOrientationIsPortrait(orientation);
}

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc
{
    // 要实现下面那一行，要在storyboard那里设置tabBarController的title，不然会是nil，看来aViewController = master的第一个view
    barButtonItem.title = aViewController.title; // 这里的aViewController指的是hide起来的ViewController，即Master
    self.navigationItem.leftBarButtonItem = barButtonItem;  // 转向Portrait后，左上角出现的button
    
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
}

@end
