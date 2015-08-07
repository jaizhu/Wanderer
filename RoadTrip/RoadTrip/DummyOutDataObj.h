//
//  DummyOutDataObj.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DummyOutDataObj : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (nonatomic) NSString *details;
@property (nonatomic) BOOL hasResults;
@property (nonatomic) BOOL ready;

@end
