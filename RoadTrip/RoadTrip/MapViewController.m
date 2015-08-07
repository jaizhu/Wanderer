//
//  MapViewController.m
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "MapViewController.h"
#import "CityObj.h"
#import "API.h"

@import GoogleMaps;

@interface MapViewController () <GMSMapViewDelegate>

@property (nonatomic, strong) GMSMapView *mapView;
@property (nonatomic, strong) NSMutableArray *polylines;
@property (nonatomic, strong) NSMutableArray *markers;

@property (nonatomic, strong) API *apiObj;
@property (nonatomic, strong) Trip *currentTrip;
@property (nonatomic) CLLocationCoordinate2D mapCoordinates;

@end

@implementation MapViewController

// MARK: Controller lifecycle
- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                           trip:(Trip *)trip {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {        
        self.apiObj = [[API alloc] init];
        self.currentTrip = trip;
        self.mapCoordinates = [self.apiObj coordinatesForCity:self.currentTrip.citiesVisited[0]];
    }
    return self;
}

// MARK: View lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mapSetup];
    
    // Path setup
    for (NSInteger i = 0; i < self.currentTrip.citiesVisited.count; i++) {
        [self pathSetupWithRouteIndex:i];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    self.mapView.padding = UIEdgeInsetsMake(self.topLayoutGuide.length + 5,
                                            0,
                                            self.bottomLayoutGuide.length + 5,
                                            0);
}

// MARK: Map and path setup
/*
 * Set up map location, view range, settings, and constraints.
 */
- (void)mapSetup {
    // Map setup
    GMSCameraPosition *camera =
    [GMSCameraPosition cameraWithLatitude:self.mapCoordinates.latitude
                                longitude:self.mapCoordinates.longitude
                                     zoom:6
                                  bearing:0
                             viewingAngle:0];
    self.mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    self.mapView.delegate = self;
    self.mapView.myLocationEnabled = NO;
    self.mapView.settings.compassButton = YES;
    [self.mapView setMinZoom:5 maxZoom:8];
    self.mapView.contentMode = UIViewContentModeScaleAspectFit;
    self.mapView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.mapView];
    
    // Map view constraints
    NSDictionary *viewNameMap = @{ @"mapView" : self.mapView };
    NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[mapView]-0-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewNameMap];
    NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[mapView]-0-|"
                                                                           options:0
                                                                           metrics:nil
                                                                             views:viewNameMap];
    [NSLayoutConstraint activateConstraints:horizontalConstraints];
    [NSLayoutConstraint activateConstraints:verticalConstraints];
}

/*
 * Sets up the route path from the city in the ith index to the city in the (i + 1)th index.
 * Also sets up the marker for the ith city.
 */
- (void)pathSetupWithRouteIndex:(NSInteger)index {
    // Set up marker for starting city
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = [self.apiObj coordinatesForCity:self.currentTrip.citiesVisited[index]];
    marker.title = [self.currentTrip.citiesVisited[index] cityName];
    marker.map = self.mapView;
    [self.markers addObject:marker];
    
    // Set up the path
    GMSPath *encodedPath = [GMSPath pathFromEncodedPath:self.currentTrip.mapPath];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:encodedPath];
    polyline.strokeWidth = 4;
    polyline.strokeColor = [UIColor blueColor];
    polyline.map = self.mapView;
    [self.polylines addObject:polyline];
}

@end
