//
//  FourthPageController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FourthPageController;

@protocol FourthPageControllerDelegate <NSObject>
- (void)proceedToTripGeneration;
@end

@interface FourthPageController : UIViewController

@property (weak, nonatomic) id <FourthPageControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIButton *createTrip;

- (IBAction)createTripButtonPressed:(id)sender;

@end
