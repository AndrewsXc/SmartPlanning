//
//  LXCImageScrollView.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCImageScrollView.h"
#import "LXCMedia.h"
@interface LXCImageScrollView()
{
    UIImageView * _zoomView;
    CGPoint _pointToCenterAfterResize;
    CGPoint _scaleToRestoreAfterResize;
}
@end
@implementation LXCImageScrollView
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self){
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

-(instancetype)init
{
    self = [super init];
    if(self){
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.bouncesZoom = YES;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.delegate = self;
    }
    return self;
}

-(void)setIndex:(NSUInteger)index
{
    _index = index;
    [self displayImage:[self imageAtIndex:index]];
}

-(NSUInteger)imageCount
{
    return _imagePaths.count;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _zoomView.frame;
   
    // center horizontally
    if(frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if(frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    _zoomView.frame = frameToCenter;

}
#pragma mark - UIScrollViewDelegate

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return _zoomView;
}

#pragma mark - Configure scrollView to display new image(tiled or not)

-(void)displayImage:(UIImage *)image
{
    // clear the previous image
    [_zoomView removeFromSuperview];
    _zoomView = nil;

    // reset our zoomScale to 1.0 before doing any further calculations
    self.zoomScale = 1.0;
    
    // make a new UIImageView for the new image
    _zoomView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:_zoomView];
    [self configureForImageSize:image.size];
}
-(void) configureForImageSize:(CGSize)imageSize
{
    _imageSize = imageSize;
    self.contentSize = imageSize;
    [self setMaxMinZoomScaleForCurrentBounds];
    self.zoomScale = self.minimumZoomScale;
}
-(void)setMaxMinZoomScaleForCurrentBounds
{
    CGSize boundsSize = [UIScreen mainScreen].bounds.size;
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGFloat xScale = boundsSize.width / _imageSize.width;
    CGFloat yScale = boundsSize.height / _imageSize.height;
    
    CGFloat minScale = MIN(xScale, yScale);
    
    // on high resolution screens we have double the pixel density, so we will be seeing every pixel if we limit the
    // maximum zoom scale to 0.5.
    CGFloat maxScale = 4. / scale;
    
    // don't let minScale exceed maxScale. (If the image is smaller than the screen, we don't want to force it to be zoomed.)
    if (minScale > maxScale)
    {
        // minScale = maxScale;
        maxScale = minScale;
    }
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
}
-(UIImage *)imageAtIndex:(NSUInteger) index
{
    UIImage *image = nil;
    LXCMedia *media = (LXCMedia *)_imagePaths[index];
    if(media.type == MP4)
        image = [UIImage imageNamed:@"playButton.png"];
    else
        image = [UIImage imageWithContentsOfFile:media.path];
    return image;
}
@end
