//
//  DetailViewController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstPageController.h"
#import "SecondPageController.h"
#import "ThirdPageController.h"
#import "FourthPageController.h"
#import "CustomizationOptions.h"

@interface DetailViewController : UIViewController <UIPageViewControllerDataSource, UIPageViewControllerDelegate, FirstPageControllerDelegate, SecondPageControllerDelegate, ThirdPageControllerDelegate, FourthPageControllerDelegate>

@property (strong, nonatomic) UIPageViewController *pageViewController;
@property (strong, nonatomic) UIPageControl *pageControl;

@property (strong, nonatomic) CustomizationOptions *customOptions;

@property (strong, nonatomic) FirstPageController *firstController;
@property (strong, nonatomic) SecondPageController *secondController;
@property (strong, nonatomic) ThirdPageController *thirdController;
@property (strong, nonatomic) FourthPageController *fourthController;

@property (weak, nonatomic) NSString *thisStringOMG;

@end
