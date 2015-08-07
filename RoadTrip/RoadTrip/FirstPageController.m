//
//  FirstPageController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/21/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "FirstPageController.h"
#import "FourthPageController.h"

@interface FirstPageController ()

@property (nonatomic, strong) NSString *selectedCity;
@property (nonatomic, strong) NSString *selectedState;

// Keep track of the last-selected row in the second component
@property (nonatomic) NSInteger lastRow;

@end

@implementation FirstPageController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataParser = [[CityDataParser alloc] initWithCSVWithPathForResource:@"CitiesPopulationsLocations"
                                                                      ofType:@"csv"];
    
    // Set up with whichever city and state will come first
    self.selectedState = [[[self.dataParser getByStateDictionary] allKeys] objectAtIndex:0];
    self.selectedCity = [[[[self.dataParser getByStateDictionary]
                            valueForKey:self.selectedState] objectAtIndex:0] objectAtIndex:0];
    self.lastRow = 0;
    
    // Fade in the swipe message
    self.swipeMessage.alpha = 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self.delegate addStartingCity:self didFinishEnteringItem:@[self.selectedCity, self.selectedState]];
}

// MARK: Picker view delegate and data source
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [[[self.dataParser getByStateDictionary] allKeys] count];
            break;
        case 1:
            return [[[self.dataParser getByStateDictionary] valueForKey:self.selectedState] count];
            break;
        default:
            return 0;
            break;
    }
}

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView
             attributedTitleForRow:(NSInteger)row
                      forComponent:(NSInteger)component {
    NSAttributedString *title = [[NSAttributedString alloc] init];
    
    switch (component) {
        case 0:
            title =
            [[NSMutableAttributedString alloc] initWithString:[[[self.dataParser getByStateDictionary]
                                                                                allKeys] objectAtIndex:row]
                                                   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            return title;
            break;
        case 1:
            title =
            [[NSMutableAttributedString alloc] initWithString:[[[[self.dataParser getByStateDictionary]
                                                                 valueForKey:self.selectedState]
                                                                objectAtIndex:row] objectAtIndex:0]
                                                   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
            return title;
            break;
        default:
            return title;
            break;
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.selectedState = [[[self.dataParser getByStateDictionary] allKeys] objectAtIndex:row];
            
            // If the index of lastRow is non-existing for the new state
            NSInteger newStateCityCt = [[[self.dataParser getByStateDictionary] valueForKey:self.selectedState] count];
            if (newStateCityCt < self.lastRow + 1) {
                self.lastRow = newStateCityCt - 1;
            }
            self.selectedCity = [[[[self.dataParser getByStateDictionary]
                                        valueForKey:self.selectedState] objectAtIndex:self.lastRow] objectAtIndex:0];
            
            [self.pickerView reloadAllComponents];
            break;
        case 1:
            self.lastRow = row;
            self.selectedCity = [[[[self.dataParser getByStateDictionary]
                                  valueForKey:self.selectedState] objectAtIndex:self.lastRow] objectAtIndex:0];
            break;
        default:
            break;
    }
    
    // Swip message
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseIn
                     animations:^{self.swipeMessage.alpha = 1;}
                     completion:nil];
}

@end
