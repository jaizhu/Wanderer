//
//  PlaceObj.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlaceObj : NSObject <NSCoding>

@property (copy, nonatomic) NSString *imageURL;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSArray *location;
@property (copy, nonatomic) NSArray *categories;
@property (copy, nonatomic) NSString *yelpURL;

@end
