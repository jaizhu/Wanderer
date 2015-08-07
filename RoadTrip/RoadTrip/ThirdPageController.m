//
//  ThirdPageController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "ThirdPageController.h"

@interface ThirdPageController ()

@end

@implementation ThirdPageController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.delegate howMuchDriving:self didFinishEnteringItem:self.drivingAmt];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: Action methods
- (IBAction)aLittlePressed:(id)sender {
    [self.aLittle setAlpha:0.9];
    [self.some setAlpha:0.5];
    [self.aLot setAlpha:0.5];
    NSLog(@"DRIVING AMOUNT: A LITTLE");
    self.drivingAmt = @1;
}
- (IBAction)somePressed:(id)sender {
    [self.aLittle setAlpha:0.5];
    [self.some setAlpha:0.9];
    [self.aLot setAlpha:0.5];
    NSLog(@"DRIVING AMOUNT: SOME");
    self.drivingAmt = @2;
}
- (IBAction)aLotPressed:(id)sender {
    [self.aLittle setAlpha:0.5];
    [self.some setAlpha:0.5];
    [self.aLot setAlpha:0.9];
    NSLog(@"DRIVING AMOUNT: A LOT");
    self.drivingAmt = @3;
}

@end
