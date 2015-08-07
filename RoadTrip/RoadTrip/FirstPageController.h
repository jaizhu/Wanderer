//
//  FirstPageController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CityDataParser.h"

@class FirstPageController;

@protocol FirstPageControllerDelegate <NSObject>
- (void)addStartingCity:(FirstPageController *)controller didFinishEnteringItem:(NSArray *)city;
@end

@interface FirstPageController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) id <FirstPageControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *swipeMessage;

@property (strong, nonatomic) CityDataParser *dataParser;

@end
