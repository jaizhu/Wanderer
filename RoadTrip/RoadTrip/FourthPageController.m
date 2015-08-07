//
//  FourthPageController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "FirstPageController.h"
#import "SecondPageController.h"
#import "ThirdPageController.h"
#import "FourthPageController.h"

#import "TripResultsViewController.h"
#import "TripResultsStore.h"

@interface FourthPageController ()

@end

@implementation FourthPageController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: Action methods
- (IBAction)createTripButtonPressed:(id)sender {
    NSLog(@"CREATING THE TRIP");
    [self.delegate proceedToTripGeneration];
}

- (IBAction)createTripTouchDown:(id)sender {
    [self.createTrip setAlpha:0.9];
}

- (IBAction)createTripButtonForgotten:(id)sender {
    [self.createTrip setAlpha:0.65];
}

@end
