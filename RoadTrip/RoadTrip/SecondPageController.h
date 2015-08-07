//
//  SecondPageController.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SecondPageController;

@protocol SecondPageControllerDelegate <NSObject>
- (void)addDaysOfTrip:(SecondPageController *)controller didFinishEnteringItem:(NSNumber *)days;
@end

@interface SecondPageController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate>

@property (weak, nonatomic) id <SecondPageControllerDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSArray *daysArray;

@end
