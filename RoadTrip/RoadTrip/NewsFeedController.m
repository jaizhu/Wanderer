//
//  NewsFeedController.m
//  RoadTrip
//
//  Created by Sophia Raji on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "NewsFeedController.h"
#import "Trip.h"

@interface NewsFeedController ()
//- (void)configureView;
@end

@implementation NewsFeedController

//@synthesize tripArray;
@synthesize _tableView;

#pragma mark - Managing the trip item

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tabBarController setTitle:@"Newsfeed"];
    
    [self configureView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self.parentViewController.navigationItem setTitle:@"News Feed"];
    
    //News feed with friend/public trips
    NewsFeedController *nfc = [[NewsFeedController alloc] initWithNibName:@"NewsFeedController" bundle:nil];
    
    nfc.tabBarItem.image=[UIImage imageNamed:@"nfc.png"];
}

- (void)configureView {
    // Update the user interface for the trip item.
    
    for(int i = 0; i < 5; i++) {
        Trip *trip = [[Trip alloc] init];
        
        self.tripArray = [[NSMutableArray alloc] initWithObjects:trip, nil];
        NSString *itinerary = [[_tripArray valueForKey:@"citiesVisited"] componentsJoinedByString:@" - "];
        
        [self.places addObject:itinerary];
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    //self.tripArray = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // typically you need know which item the user has selected.
    // this method allows you to keep track of the selection
    
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewCellEditingStyleDelete;
}

// This will tell your UITableView how many rows you wish to have in each section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.tripArray count];
}

// This will tell your UITableView what data to put in which cells in your table.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifer = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    // Using a cell identifier will allow your app to reuse cells as they come and go from the screen.
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifer];
    }
    
    //Trip *trip = [[Trip alloc] init];
    
    // Deciding which data to put into this particular cell.
    // If it the first row, the data input will be "Data1" from the array.
    NSUInteger row = [indexPath row];
    
    cell.textLabel.text = [self.places objectAtIndex:row];
    
    /*
     dateCreated = [NSDate date];
     options.startingLocation = @"Starting city";
     options.tripDuration = @1;
     options.farthestPointDistance = @120;
     options.citiesVisited
     */
    
    return cell;
}

@end
