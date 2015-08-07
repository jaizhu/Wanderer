//
//  MyTripsViewController.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 8/3/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "MyTripsViewController.h"
#import "TripInfoViewController.h"
#import "MapViewController.h"
#import "TripSaver.h"
#import "ResultCell.h"
#import "CityObj.h"

static NSString *kResultCellReuseIdentifier = @"ResultCell";

@interface MyTripsViewController ()

@property (nonatomic, strong) TripSaver *tripSaver;

@end

@implementation MyTripsViewController

- (instancetype)init {
    self = [super init];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Set background image
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:self.view.frame];
    backgroundImageView.image = [UIImage imageNamed:@"user.jpg"];
    backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view insertSubview:backgroundImageView atIndex:0];
    
    // Customizing table view
    [self.tableView setBackgroundColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3]];
    
    // Set navigation bar
    [self.parentViewController.navigationItem setTitle:@"My Trips"];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tripSaver = [[TripSaver alloc] init];
    
    NSLog(@"My Trips appeared");
    
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.tripSaver saveChanges];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// MARK: Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.tripSaver.savedTrips count] == 0) {
        return 0;
    } else {
        return [self.tripSaver.savedTrips count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Get a new or recycled cell
    ResultCell *cell =
    [self.tableView dequeueReusableCellWithIdentifier:kResultCellReuseIdentifier
                                         forIndexPath:indexPath];
    
    // Setup results cell
    [cell setupCellUI];
    [cell setupResultCell:[self.tripSaver.savedTrips objectAtIndex:indexPath.row]];
    
    // If dequeue returns nil, create cell
    if (!cell) {
        cell = [[ResultCell alloc] initWithStyle:UITableViewCellStyleDefault
                                 reuseIdentifier:kResultCellReuseIdentifier];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"Delete this trip");
        
        // Delete from store
        Trip *deletedTrip = [self.tripSaver.savedTrips objectAtIndex:indexPath.row];
        [self.tripSaver.savedTrips removeObject:deletedTrip];
        BOOL success = [self.tripSaver saveChanges];
        if (success) {
            NSLog(@"Deleted trip successfully");
        } else {
            NSLog(@"Could not delete trip");
        }
        
        // Delete from the table view
        [self.tableView deleteRowsAtIndexPaths:@[indexPath]
                              withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

// MARK: Table view delegate
- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Trip *selectedTrip = [self.tripSaver.savedTrips objectAtIndex:indexPath.row];
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
    NSString *tripName =
    [NSString stringWithFormat:@"%@, %@ +%lu more",[[selectedTrip.citiesVisited firstObject] cityName], [[selectedTrip.citiesVisited objectAtIndex:1] cityName], ([selectedTrip.citiesVisited count] - 2)];
    tbvc.navigationItem.title = tripName;
    tbvc.tabBar.barTintColor = [UIColor blackColor];
    tbvc.view.tintColor = [UIColor whiteColor];
    tbvc.tabBar.backgroundColor = [UIColor blackColor];
    
    [self.navigationController pushViewController:tbvc animated:YES];
}

@end
