//
//  MapViewController.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 7/6/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Trip.h"

@interface MapViewController : UIViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil
                         bundle:(NSBundle *)nibBundleOrNil
                           trip:(Trip *)trip NS_DESIGNATED_INITIALIZER;

@end
