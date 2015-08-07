//
//  ThirdPageController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ThirdPageController;

@protocol ThirdPageControllerDelegate <NSObject>
- (void)howMuchDriving:(ThirdPageController *)controller didFinishEnteringItem:(NSNumber *)drivingAmt;
@end

@interface ThirdPageController : UIViewController

@property (weak, nonatomic) id <ThirdPageControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *aLittle;
@property (weak, nonatomic) IBOutlet UIButton *some;
@property (weak, nonatomic) IBOutlet UIButton *aLot;
@property (nonatomic) NSNumber *drivingAmt;

- (IBAction)aLittlePressed:(id)sender;
- (IBAction)somePressed:(id)sender;
- (IBAction)aLotPressed:(id)sender;

@end
