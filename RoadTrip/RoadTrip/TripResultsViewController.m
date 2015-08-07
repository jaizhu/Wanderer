//
//  ResultsViewController.m
//  RoadTrip
//
//  Created by Sophia Raji on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "TripResultsViewController.h"
#import "TripInfoViewController.h"
#import "MapViewController.h"
#import "TripResultsStore.h"
#import "ResultCell.h"
#import "Trip.h"
#import "CityObj.h"

static NSString *kResultCellReuseIdentifier = @"ResultCell";

@interface TripResultsViewController ()

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) TripResultsStore *resultsStore;
@property (nonatomic, copy) NSString *tripName;

@end

@implementation TripResultsViewController

// MARK: Controller lifecycle
- (instancetype)initWithTripResultsStore:(TripResultsStore *)store {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        self.resultsStore = store;
    }
    return self;
}

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Setting background
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"info.jpg"]]];
    
    UINib *resultCellNib = [UINib nibWithNibName:kResultCellReuseIdentifier bundle:nil];
    [self.tableView registerNib:resultCellNib forCellReuseIdentifier:kResultCellReuseIdentifier];
    
    self.navigationItem.title = @"Trip Results";
    [self.navigationController setNavigationBarHidden:NO];
    
    // Set back button to instead return to home screen
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel"
                                                                     style:UIBarButtonItemStylePlain
                                                                    target:self
                                                                    action:@selector(backButtonPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    // Customizing table view
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

// MARK: Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.resultsStore.resultsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a new or recycled cell
    ResultCell *cell =
    [tableView dequeueReusableCellWithIdentifier:kResultCellReuseIdentifier
                                    forIndexPath:indexPath];
    
    // Customize cell
    [cell setupCellUI];
    
    // If dequeue returns nil, create cell
    if (!cell) {
        cell = [[ResultCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:kResultCellReuseIdentifier];
    }
    
    // Set cells of trips to be displayed
    Trip *indexedTrip = [self.resultsStore.resultsList objectAtIndex:indexPath.row];
    self.tripName =
    [NSString stringWithFormat:@"%@, %@ +%lu more",[[indexedTrip.citiesVisited firstObject] cityName], [[indexedTrip.citiesVisited objectAtIndex:1] cityName], ([indexedTrip.citiesVisited count] - 2)];
    cell.RTripNameLabel.text = self.tripName;
    cell.RTripDrivingAmt.text = [NSString stringWithFormat:@"Drive up to %ld miles per day",
                                 (long)([indexedTrip.farthestPointDistance floatValue] / 1.6)];
    cell.RTripCategoriesLabel.text = [NSString stringWithFormat:@"%@ & %@", indexedTrip.tripCategoryA, indexedTrip.tripCategoryB];
    self.stateName = [NSString stringWithFormat:@"%@", [[indexedTrip.citiesVisited firstObject] cityState]];
    
    return cell;
}

// MARK: Table view delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Trip *selectedTrip = [self.resultsStore.resultsList objectAtIndex:indexPath.row];
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"TripInfoViewController" bundle:nil];
    TripInfoViewController *tivc = [story instantiateInitialViewController];
    tivc.tabBarItem.title = @"Cities to Visit";
    tivc.tabBarItem.image = [UIImage imageNamed:@"listIcon"];
    
    tivc.currentTrip = selectedTrip;
    
    MapViewController *mvc = [[MapViewController alloc] initWithNibName:nil
                                                                 bundle:nil
                                                                   trip:selectedTrip];
    mvc.tabBarItem.title = @"Trip Map";
    mvc.tabBarItem.image = [UIImage imageNamed:@"mapIcon"];

    // Setting up the tab bar view controller
    UITabBarController *tbvc = [[UITabBarController alloc] init];
    tbvc.viewControllers = @[tivc, mvc];
    tbvc.navigationItem.title = [NSString stringWithFormat:@"%@ Trip", self.stateName];
    tbvc.tabBar.barTintColor = [UIColor blackColor];
    tbvc.view.tintColor = [UIColor whiteColor];
    tbvc.tabBar.backgroundColor = [UIColor blackColor];

    [self.navigationController pushViewController:tbvc animated:YES];
}

// MARK: Target-action callbacks
-(void)backButtonPressed:(UIBarButtonItem *)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
