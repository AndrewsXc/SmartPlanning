//
//  LXCBigPhotoViewController.m
//  SmartPlanning
//
//  Created by yaqiannnn on 2018/11/20.
//  Copyright © 2018年 NJU. All rights reserved.
//

#import "LXCBigPhotoViewController.h"
#import "LXCPhotoViewController.h"

@interface LXCBigPhotoViewController ()

@end

@implementation LXCBigPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LXCPhotoViewController *pageZero = [LXCPhotoViewController photoViewControllerForPageIndex:_currentIndex withSegueName:_segueName andImagePaths:_imagePaths];
    if (pageZero != nil)
    {
        // assign the first page to the pageViewController (our rootViewController)
        UIPageViewController *pageViewController = self;
        pageViewController.dataSource = self;
        
        [pageViewController setViewControllers:@[pageZero]
                                     direction:UIPageViewControllerNavigationDirectionForward
                                      animated:NO
                                    completion:NULL];
    }
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerBeforeViewController:(LXCPhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [LXCPhotoViewController photoViewControllerForPageIndex:(index - 1) withSegueName:_segueName andImagePaths:_imagePaths];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pvc viewControllerAfterViewController:(LXCPhotoViewController *)vc
{
    NSUInteger index = vc.pageIndex;
    return [LXCPhotoViewController photoViewControllerForPageIndex:(index + 1) withSegueName:_segueName andImagePaths:_imagePaths];
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

@end
