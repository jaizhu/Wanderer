//
//  TSPSolution.h
//  RoadTrip
//
//  Created by Carlos Mendizabal on 8/2/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSPSolution : NSObject

@property (nonatomic, copy) NSString *encodedPath;
@property (nonatomic, copy) NSArray *citiesInOrder;
@property (nonatomic, copy) NSNumber *longestDistance;

@end
