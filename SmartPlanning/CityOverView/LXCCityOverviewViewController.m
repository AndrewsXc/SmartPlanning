//
//  LXCCityOverviewViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/25.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCCityOverviewViewController.h"
#import "LXCMedia.h"
@interface LXCCityOverviewViewController ()
{
    NSInteger _selectedIndex;
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet iCarousel *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *imageInfo;
@end

@implementation LXCCityOverviewViewController

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setViewOfCityOverView];
}

-(void)setViewOfCityOverView{
    //未采用imageNamed 因为imageName会缓存图片 不常用的大图片建议不要用imageNamed
    _backgroundImageView.image = [UIImage imageNamed:@"CityoverviewBg"];
    _imageListView.backgroundColor = [UIColor clearColor];
    _imageListView.type = iCarouselTypeLinear;
    _imageListView.dataSource = self;
    _imageListView.delegate = self;
    _imageListView.bounceDistance = 0.3;
    _imageInfo.text=((LXCMedia*)_imagePaths[_imageListView.currentItemIndex]).title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel的委托方法
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    _imagePaths = [LXCMedia getMediasCityOverviewSceneDir];
    return _imagePaths.count;
}
-(UIView*)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if(view == nil)//nil OC对象 Nil 自定义类对象
    {
        FXImageView* imageView = [[FXImageView alloc] initWithFrame:CGRectMake(0, 0, 250.f, 250.f) ];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.asynchronous = NO;//异步 若开启异步则报：应在主线程中运行警告
        imageView.reflectionScale = 0.3f;
        imageView.reflectionAlpha = 0.25f;
        imageView.reflectionGap = 3.0f;
        imageView.cornerRadius = 4.0f;
        
        LXCMedia*im = _imagePaths[index];
        imageView.image = [UIImage imageWithContentsOfFile:im.path];
    
        if (imageView.image.size.height < imageView.image.size.width)
        {
            imageView.frame = CGRectMake(0.,(250.- 250.*imageView.image.size.height/imageView.image.size.width)/2.-30, 250., 250.);
        }
        else
        {
            imageView.frame = CGRectMake(0.,-30, 250., 250.);
        }
        view = imageView;
    }
  

    return view;
}
-(void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel
{
    _imageInfo.text=((LXCMedia*)_imagePaths[_imageListView.currentItemIndex]).title;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
