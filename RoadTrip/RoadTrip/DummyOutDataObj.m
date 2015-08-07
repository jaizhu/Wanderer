//
//  DummyOutDataObj.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/13/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "DummyOutDataObj.h"

@implementation DummyOutDataObj

- (instancetype)initWithName: (NSString *)name
                     address: (NSString *)address
                     details: (NSString *)details {
    self = [super init];
    
    if(self) {
        self.name = name;
        self.address = address;
        self.details = details;
    }
    return self;
}

@end
