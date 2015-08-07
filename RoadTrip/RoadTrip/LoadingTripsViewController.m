//
//  LoadingTripsViewController.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/24/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "LoadingTripsViewController.h"

@interface LoadingTripsViewController ()
@property (copy, nonatomic) NSArray *messages;
@property (copy, nonatomic) NSMutableArray *displayMessages;
@property (nonatomic) int index;
@property (nonatomic) NSInteger messageTime;
@end

@implementation LoadingTripsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = @[@"Calculating distance...", @"Searching for places...", @"Calibrating route...", @"Generating your trip..."];
    self.index = 0;
    self.messageTime = 3;
    
    // Setting background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"info.jpg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationItem setHidesBackButton:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSMethodSignature *methodSig = [self methodSignatureForSelector:@selector(nextMessage)];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSig];
    [invocation setTarget:self];
    [invocation setSelector:@selector(nextMessage)];
    
    // Random time hehe
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.messageTime
                                                  invocation:invocation
                                                     repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:timer forMode:NSDefaultRunLoopMode];
}

// MARK: Timer methods
- (void)nextMessage {
    // puts the next message in the display messages array and displays its
    if (self.index < [self.messages count]) {
        self.message.text = [self.messages objectAtIndex:self.index];
        self.index++;
        ++self.messageTime;
    } else if (self.index == [self.messages count]) {
        return;
    }
}

@end
