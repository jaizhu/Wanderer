//
//  RedirectToCustomViewController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/23/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "RedirectToCustomViewController.h"
#import "DetailViewController.h"

@interface RedirectToCustomViewController ()

@property (nonatomic, weak) DetailViewController *dvc;
@property (nonatomic) BOOL hasLoaded;

@end

@implementation RedirectToCustomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // Allocate the storyboard each time to restart from page 1
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Customize" bundle:nil];
    self.dvc = [storyboard instantiateInitialViewController];
    
    // Sends either to Customization view or to Profile view depending on whether user last went to customization or not
    if (self.hasLoaded) {
        self.hasLoaded = NO;
        // Go to tab bar
        self.tabBarController.selectedIndex = 0;
        [self.navigationController popToRootViewControllerAnimated:YES];
    } else {
        self.hasLoaded = YES;
        [self.navigationController pushViewController:self.dvc animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
