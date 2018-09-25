//
//  LXCCityOverviewViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/9/25.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCCityOverviewViewController.h"

@interface LXCCityOverviewViewController ()
{
    NSInteger _selectedIndex;
}
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet iCarousel *imageListView;
@property (weak, nonatomic) IBOutlet UILabel *ImageInfo;
@end

@implementation LXCCityOverviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - iCarousel的委托方法
-(NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
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
        view = imageView;
    }
//    UIImage *image=[UIImage imageNamed:_items[index]];
//    [view setValue:image forKey:@"image"];
    return view;
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
