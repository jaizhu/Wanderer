//
//  UserViewController.m
//  RoadTrip
//
//  Created by Sophia Raji on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "UserViewController.h"
#import "TripSaver.h"

@implementation UserViewController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    NSString *archivePath = [tripSaver tripsArchivePath];
//    NSArray *archivedTrips = [NSKeyedUnarchiver unarchiveObjectWithFile:archivePath];
//    [self.savedTrips addObjectsFromArray:archivedTrips];
    
    // Set background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"user.jpg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.parentViewController.navigationItem setTitle:@"My Trips"];
}

// MARK: Display things
- (void)addTripToSavedTrips:(Trip *)trip {
    [self.savedTrips addObject:trip];
}

@end
