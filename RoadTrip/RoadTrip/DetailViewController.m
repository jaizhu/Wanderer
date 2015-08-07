//
//  DetailViewController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "DetailViewController.h"
#import "FirstPageController.h"
#import "SecondPageController.h"
#import "ThirdPageController.h"
#import "FourthPageController.h"

#import "TripResultsStore.h"
#import "TripResultsViewController.h"
#import "LoadingTripsViewController.h"

@interface DetailViewController ()

@end

// MARK: Constants
static const NSInteger numberOfPages = 4;

@implementation DetailViewController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Initializes the customization options
    self.customOptions = [[CustomizationOptions alloc] init];
    
    // UI Config
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    // Data model for all page controllers
    NSNumber *pageSpacing = [[NSNumber alloc] initWithFloat:2.0];
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                                                              navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                                                            options:[NSDictionary dictionaryWithObjects:@[pageSpacing] forKeys:@[UIPageViewControllerOptionInterPageSpacingKey]]];
    
    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;
    
    // Page control UI
    self.pageControl = [UIPageControl appearance];
    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
    UIColor *pageControlBackground = [UIColor blackColor];
    self.pageControl.backgroundColor = pageControlBackground;
    [self.view addSubview:self.pageControl.viewForBaselineLayout];
    
    // Creates the data model
    UIViewController *firstViewController = [self viewControllerAtIndex:0];
    
    [self.pageViewController setViewControllers:@[firstViewController]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];
    
    // Changes the size of the page view controller
    self.pageViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: Setter methods for content controllers
- (FirstPageController *)firstController {
    if (_firstController == nil) {
        _firstController = [self.storyboard instantiateViewControllerWithIdentifier:@"FirstPageController"];
        _firstController.delegate = self;
    }
    return _firstController;
}

- (SecondPageController *)secondController {
    if (_secondController == nil) {
        _secondController = [self.storyboard instantiateViewControllerWithIdentifier:@"SecondPageController"];
        _secondController.delegate = self;
    }
    return _secondController;
}

- (ThirdPageController *)thirdController {
    if (_thirdController == nil) {
        _thirdController = [self.storyboard instantiateViewControllerWithIdentifier:@"ThirdPageController"];
        _thirdController.delegate = self;
    }
    return _thirdController;
}

- (FourthPageController *)fourthController {
    if (_fourthController == nil) {
        _fourthController = [self.storyboard instantiateViewControllerWithIdentifier:@"FourthPageController"];
        _fourthController.delegate = self;
    }
    return _fourthController;
}

// MARK: Page View Controller Data Source
- (UIViewController *)viewControllerAtIndex:(NSInteger)index {
    if ((index < 0) || (index >= numberOfPages)) {
        return nil;
    }
    
    if (index == 0) {
        return self.firstController;
    } else if (index == 1) {
        return self.secondController;
    } else if (index == 2) {
        return self.thirdController;
    } else if (index == 3) {
        return self.fourthController;
    } else {
        return nil;
    }
}

- (NSInteger)getIndex:(NSString *)restorationID {
    NSInteger x;
    if ([restorationID isEqualToString:@"FirstPageController"]) {
        NSLog(@"....................... Getting/loading first view");
        x = 0;
    } else if ([restorationID isEqualToString:@"SecondPageController"]) {
        NSLog(@"....................... Getting/loading second view");
        x = 1;
    } else if ([restorationID isEqualToString:@"ThirdPageController"]) {
        NSLog(@"....................... Getting/loading third view");
        x = 2;
    } else if ([restorationID isEqualToString:@"FourthPageController"]) {
        NSLog(@"....................... Getting/loading fourth view");
        x = 3;
    } else {
        NSLog(@"Error: Cannot find view");
        // DO THIS BETTER
        return 999;
    }
    return x;
}

- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return numberOfPages;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}

// MARK: UIPageViewControllerDelegate methods
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(UIViewController *)viewController {
    NSString * ident = viewController.restorationIdentifier;
    NSInteger index = [self getIndex:ident];

    return [self viewControllerAtIndex:(index - 1)];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(UIViewController *)viewController {
    NSString * ident = viewController.restorationIdentifier;
    NSInteger index = [self getIndex:ident];
    
    return [self viewControllerAtIndex:(index + 1)];
}

// MARK: Data collection methods
- (void)addStartingCity:(FirstPageController *)controller didFinishEnteringItem:(NSArray *)city {
    self.customOptions.startingCity = city;
    NSLog(@"The starting city is: %@, %@", city[0], city[1]);
}

- (void)addDaysOfTrip:(SecondPageController *)controller didFinishEnteringItem:(NSNumber *)days {
    self.customOptions.tripDuration = days;
    NSLog(@"TRIP DURATION: %@ days", days);
}

- (void)howMuchDriving:(ThirdPageController *)controller didFinishEnteringItem:(NSNumber *)drivingAmt {
    if ([drivingAmt  isEqual: @3]) {
        self.customOptions.farthestDistanceInHours = @10;
    } else if ([drivingAmt  isEqual: @2]) {
        self.customOptions.farthestDistanceInHours = @6;
    } else if ([drivingAmt isEqual:@1]) {
        self.customOptions.farthestDistanceInHours = @3;
    } else {
        self.customOptions.farthestDistanceInHours = nil;
    }
    NSLog(@"DISTANCE OF TRIP: %@ hours away", self.customOptions.farthestDistanceInHours);
}

// MARK: Generating the trip
- (void)proceedToTripGeneration {
    // Check that options are being provided, if not then return to Home view
    if (!self.customOptions.farthestDistanceInHours) {
        
        UIAlertView *optionsMissingAlert = [[UIAlertView alloc] initWithTitle:@"Some options have not beeen entered"
                                                                      message:@"Swipe back to fill in "
                                                                                "all the options."
                                                                     delegate:nil
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
        [optionsMissingAlert show];
    }
    else {
        [self pushTripResultsViewControllerToStack];
    }
}

- (void)pushTripResultsViewControllerToStack {
    dispatch_queue_t tripGenerationQueue = dispatch_queue_create ("Trip Generation", DISPATCH_QUEUE_SERIAL);
    
    void (^__tripGenCompletionHandler)(TripResultsStore *) = ^(TripResultsStore *resultsStore) {
        // If no results are given, show no internet error message and return to Home View, exiting completion handler
        if (!resultsStore.resultsList) {
            NSLog(@"Error, Trip Results Store could not be generated");
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView *noConnectionAlert = [[UIAlertView alloc] initWithTitle:@"No network connection"
                                                                            message:@"You must be connected to "
                                                                                    "the internet to generate a trip."
                                                                           delegate:nil
                                                                  cancelButtonTitle:@"OK"
                                                                  otherButtonTitles:nil];
                [noConnectionAlert show];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
            });
            
            return;
        }
        
        // Create trip results view controller and then push to navigation stack from main queue
        TripResultsViewController *trvc =
        [[TripResultsViewController alloc] initWithTripResultsStore:resultsStore];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.navigationController pushViewController:trvc animated:YES];
        });
        
        return;
    };
    
    // Generate trip results
    dispatch_async(tripGenerationQueue, ^{
        TripResultsStore *resultsStore = [[TripResultsStore alloc] initWithOptions:self.customOptions];
        
        __tripGenCompletionHandler(resultsStore);
    });
    
    // Go to loading screen in meantime
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoadingTripsViewController" bundle:nil];
    LoadingTripsViewController *ltvc = [storyboard instantiateInitialViewController];
    
    [self.navigationController pushViewController:ltvc animated:YES];
}

@end
