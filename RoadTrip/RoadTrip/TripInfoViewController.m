//
//  TripInfoViewController.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "TripInfoViewController.h"
#import "TripOptions.h"
#import "CityObj.h"
#import "TripSaver.h"
#import "DropDownTableViewCell.h"
#import "TopLevelTableViewCell.h"
#import "PlaceObj.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

static NSString *kCityCellReuseIdentifier = @"CityCell";
static NSString *kNumberOfPlacesDisplayed = @"5";
static NSString *kNumberOfPlacesA = @"3";
static NSString *kNumberOfPlacesB = @"2";

@interface TripInfoViewController ()

@property (nonatomic, strong) TripSaver *tripSaver;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (strong, nonatomic) NSMutableArray *cells;

@end

@implementation TripInfoViewController

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSInteger numPlacesTotal = [kNumberOfPlacesDisplayed integerValue];
    NSInteger numPlacesA = [kNumberOfPlacesA integerValue];
    NSInteger numPlacesB = [kNumberOfPlacesB integerValue];
    self.navigationItem.title = @"Trip Name Here";
    
    self.tripSaver = [[TripSaver alloc] init];
    self.cells = [[NSMutableArray alloc] init];
    
    // For each city
    for (int i = 0; i < [self.currentTrip.citiesVisited count]; ++i) {
        TopLevelTableViewCell *topCell = [self.tableView dequeueReusableCellWithIdentifier:@"topID"];
        [topCell setupTopLevelCell:[self.currentTrip.citiesVisited objectAtIndex:i]];
        
        // Check how many places there are per category
        NSInteger numPlacesCategoryA = [[[[self.currentTrip.citiesVisited objectAtIndex:i] placesDict] valueForKey:self.currentTrip.tripCategoryA] count];
        NSInteger numPlacesCategoryB = [[[[self.currentTrip.citiesVisited objectAtIndex:i] placesDict] valueForKey:self.currentTrip.tripCategoryB] count];

        // If there's not enough in both categories
        if (numPlacesCategoryA + numPlacesCategoryB < numPlacesTotal) {
            NSArray *allKeys = [[[self.currentTrip.citiesVisited objectAtIndex:i] placesDict] allKeys];
            for (int m = 0; m < numPlacesTotal; ++m) {
                [self dropDownCellsForTopLevelCell:topCell
                               indexOfDropDownCell:m
                                       indexOfCity:i
                                          category:[allKeys objectAtIndex:m]];
            }
        } else if (numPlacesCategoryA < numPlacesA && numPlacesCategoryB > numPlacesTotal - numPlacesCategoryA) {
            for (int n = 0; n < numPlacesCategoryA; ++n) {
                [self dropDownCellsForTopLevelCell:topCell
                               indexOfDropDownCell:n
                                       indexOfCity:i
                                          category:self.currentTrip.tripCategoryA];
            }
            for (int o = (int)numPlacesCategoryA; o < (numPlacesTotal - numPlacesCategoryA); ++o) {
                [self dropDownCellsForTopLevelCell:topCell
                               indexOfDropDownCell:o
                                       indexOfCity:i
                                          category:self.currentTrip.tripCategoryB];
            }
        } else if (numPlacesCategoryB < numPlacesB && numPlacesCategoryA > numPlacesTotal - numPlacesCategoryB) {
            for (int p = 0; p < numPlacesCategoryB; ++p) {
                [self dropDownCellsForTopLevelCell:topCell
                               indexOfDropDownCell:p
                                       indexOfCity:i
                                          category:self.currentTrip.tripCategoryB];
            }
            for (int q = (int)numPlacesCategoryB; q < (numPlacesTotal - numPlacesCategoryB); ++q) {
                [self dropDownCellsForTopLevelCell:topCell
                               indexOfDropDownCell:q
                                       indexOfCity:i
                                          category:self.currentTrip.tripCategoryA];
            }
        }
        
        // For the places of categoryA
        for (int j = 0; j < numPlacesA; ++j) {
            [self dropDownCellsForTopLevelCell:topCell
                           indexOfDropDownCell:j
                                   indexOfCity:i
                                      category:self.currentTrip.tripCategoryA];
        }
        
        // For the places of categoryB
        int startB = (int)(numPlacesA);
        for (int l = startB; l < numPlacesTotal; ++l) {
            [self dropDownCellsForTopLevelCell:topCell
                           indexOfDropDownCell:l
                                   indexOfCity:i
                                      category:self.currentTrip.tripCategoryB];
        }
        
        // Add the places to the city
        [self.cells addObject:topCell];
    }
    
    // Setting background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"info.jpg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    // UI Tweaking
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.saveButton setHighlighted:NO];
}

- (void)dropDownCellsForTopLevelCell:(TopLevelTableViewCell *)topCell
                 indexOfDropDownCell:(NSInteger) j
                         indexOfCity:(NSInteger) i
                            category:(NSString *)category {
    DropDownTableViewCell *dropdownCell = [self.tableView dequeueReusableCellWithIdentifier:@"dropdownID"];
    
    // Set values for the cell
    [dropdownCell setupDropdownCellUI];
    [topCell setupDropdownCell:dropdownCell
           indexOfDropdownCell:j];
    
    // Fetching data
    PlaceObj *placeForKey = [[[[self.currentTrip.citiesVisited objectAtIndex:i] placesDict] objectForKey:category] objectAtIndex:j];
    // Image stuff
    dispatch_async(kBgQueue, ^{
        NSString *urlString = placeForKey.imageURL;
        NSURL *url = [NSURL URLWithString:urlString];
        NSData *data = [NSData dataWithContentsOfURL:url];
        if (data) {
            UIImage *image = [UIImage imageWithData:data];
            if (image) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [dropdownCell.image setImage:image];
                });
            }
        }
    });
    // Name stuff
    dropdownCell.name.text = placeForKey.name;
    // Category stuff
    NSMutableString *final = [[NSMutableString alloc] init];
    for (int k = 0; k < [placeForKey.categories count]; ++k) {
        NSArray *singleCategoryArr = [placeForKey.categories objectAtIndex:k];
        [final appendString:[singleCategoryArr objectAtIndex:0]];
        [final appendString:@" * "];
    }
    [final deleteCharactersInRange:NSMakeRange([final length] - 3, 3)];
    dropdownCell.categories.text = final;
    // URL stuff
    dropdownCell.actualYelpURL = placeForKey.yelpURL;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// MARK: Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.cells.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.cells objectAtIndex:indexPath.row];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.selected = NO;
    cell.highlighted = NO;
    
    // Getting rid of lines
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    TopLevelTableViewCell *topLevelCell;
    if ((topLevelCell = (TopLevelTableViewCell *)cell)) {
        //Basically ignoring taps on the drop down cell.
        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:(indexPath.row + 1) inSection:indexPath.section];
        NSArray *indexPaths = @[nextIndexPath, [NSIndexPath indexPathForRow:nextIndexPath.row + 1 inSection:0], [NSIndexPath indexPathForRow:nextIndexPath.row + 2 inSection:0], [NSIndexPath indexPathForRow:nextIndexPath.row + 3 inSection:0], [NSIndexPath indexPathForRow:nextIndexPath.row + 4 inSection:0]];
        NSInteger start = nextIndexPath.row;
        UITableViewCell *thisCell = [self.tableView cellForRowAtIndexPath:indexPath];
        UITableViewCell *nextCell = [self.tableView cellForRowAtIndexPath:nextIndexPath];
        
        int isTopCell = 0;
        UITableViewCell *tempNextCell = nextCell;
        for (int i = 1; i <= [kNumberOfPlacesDisplayed integerValue]; ++i) {
            // Check how many dropDownCells (inclusive) are trailing behind the selected cell
            if ([tempNextCell isKindOfClass:[DropDownTableViewCell class]]) {
                ++isTopCell;
            }
            tempNextCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:(start + i) inSection:0]];
        }
        
        if ([nextCell isKindOfClass:[DropDownTableViewCell class]] && [thisCell isKindOfClass:[TopLevelTableViewCell class]]) {
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_down"]];
            // Collapse them
            [self.cells removeObjectsInRange:NSMakeRange(start, 5)];
            [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
        } else if ([thisCell isKindOfClass:[TopLevelTableViewCell class]]) {
            // Insert dropDown cells
            cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow_up"]];
            [self.cells insertObject:topLevelCell.dropDownCell1 atIndex:start];
            [self.cells insertObject:topLevelCell.dropDownCell2 atIndex:start + 1];
            [self.cells insertObject:topLevelCell.dropDownCell3 atIndex:start + 2];
            [self.cells insertObject:topLevelCell.dropDownCell4 atIndex:start + 3];
            [self.cells insertObject:topLevelCell.dropDownCell5 atIndex:start + 4];
            
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        } else if ([thisCell isKindOfClass:[DropDownTableViewCell class]]) {
            DropDownTableViewCell *currentCell = (DropDownTableViewCell *)thisCell;
            self.yelpURL = currentCell.actualYelpURL;
            return;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.cells objectAtIndex:indexPath.row] isKindOfClass:[TopLevelTableViewCell class]]) {
        return 48.0;
    }
    return 90.0;
}

// MARK: Open Yelp URL in Safari
- (IBAction)openInYelp:(id)sender {
    NSLog(@"URL opened");
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.yelpURL]];
}


// MARK: Save the trip to your trips
- (IBAction)saveButtonPressed:(id)sender {
    TripSaver *saver = [[TripSaver alloc] init];
    [saver saveTrip:self.currentTrip];
}

- (IBAction)saveButtonTouchDOwn:(id)sender {
    [self.saveButton setAlpha:0.9];
}

- (IBAction)saveButtonForgotten:(id)sender {
    [self.saveButton setAlpha:0.65];
}

@end
