//
//  LXCMainMenuViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/24.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCMainMenuViewController.h"

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
@interface LXCMainMenuViewController () <iCarouselDataSource,iCarouselDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (weak,   nonatomic) IBOutlet iCarousel *mainView;
@property (strong, nonatomic) NSMutableArray *items;
@property (assign, nonatomic) ViewControllerType currentViewControllerType;
@end

@implementation LXCMainMenuViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    [self setMainView];

}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
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
    _imageView.image = [UIImage imageNamed:@"MainBackground"];
    _currentViewControllerType = 0;
    _mainView.backgroundColor = [UIColor clearColor];
    _mainView.scrollSpeed = 1;
    _mainView.scrollToItemBoundary = YES;
    _mainView.type = iCarouselTypeCoverFlow;
    _mainView.dataSource = self;
    _mainView.delegate = self;
   
//    //LXC 20170629 back to 返回
//    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] init];
//    backItem.title = @"返回";
//    self.navigationItem.backBarButtonItem = backItem;
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
        imageView.asynchronous = NO;//异步 若开启异步则报：应在主线程中运行警告
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
-(void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    switch (index) {
        case 0:
            [self performSegueWithIdentifier:@"toCityOverview" sender:self];
            break;
           
        case 1:
            [self performSegueWithIdentifier:@"toGeneralPlan" sender:self];
            break;
            
        default:
            break;
    }
}
@end
