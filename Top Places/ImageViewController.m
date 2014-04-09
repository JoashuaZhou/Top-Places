//
//  ImageViewController.m
//  Top Places
//
//  Created by Joshua Zhou on 14-4-5.
//  Copyright (c) 2014年 Joshua Zhou. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end

@implementation ImageViewController

#pragma mark - iPad support
//- (void)awakeFromNib
//{
//
//}

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
    [self.spinner startAnimating];
    
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
@end
