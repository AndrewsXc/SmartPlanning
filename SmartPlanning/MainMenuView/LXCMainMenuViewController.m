//
//  LXCMainMenuViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/24.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCMainMenuViewController.h"
#import <iCarousel.h>
#import <FXImageView.h>
typedef NS_ENUM(NSInteger, ViewControllerType)
{
    ViewControllerTypeCityOverView      = 0,
    ViewControllerTypeGeneralPlan,
    ViewControllerTypeCityConstructFormerYear,
    ViewControllerTypeCityConstructLatterYear,
    ViewControllerTypeMapView,
    ViewControllerTypeDocument,
    ViewControllerTypeAboutUs,
};
@interface LXCMainMenuViewController ()<iCarouselDataSource,iCarouselDelegate>
@property (weak, nonatomic) IBOutlet iCarousel *mainView;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, assign) ViewControllerType currentViewControllerType;
@end

@implementation LXCMainMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setMainView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)setMainView{
    UIImage * bgimage = [UIImage imageNamed:@"MainBackground"];
    [_mainView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:bgimage]];
    _currentViewControllerType = 0;
    _mainView.scrollSpeed = 10;
    _mainView.scrollToItemBoundary = YES;
    _mainView.type = iCarouselTypeCoverFlow;
    _mainView.dataSource = self;
    _mainView.delegate = self;
   
}

#pragma mark iCarousel
- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    _currentViewControllerType = [_mainView currentItemIndex];
}
- (nonnull UIView *)carousel:(nonnull iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIView *)view {
    if(view == nil)//nil OC对象 Nil 自定义类对象
    {
        FXImageView* imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 600.f, 300.f) ];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = YES;
        imageView.reflectionScale = 0.5f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 10.0f;
        imageView.cornerRadius = 10.0f;
        view = imageView;
    }
    UIImage *image=[UIImage imageNamed:_items[index]];
    [view setValue:image forKey:@"image"];
    return view;
}

- (NSInteger)numberOfItemsInCarousel:(nonnull iCarousel *)carousel {
    _items = [@[@"CityOverView",
                @"GeneralPlan",
                @"CityConstructFormerYear",
                @"CityConstructLatterYear",
                @"MapView",
                @"Document",
                @"AboutUs"] mutableCopy];
    return [_items count];
}

@end
