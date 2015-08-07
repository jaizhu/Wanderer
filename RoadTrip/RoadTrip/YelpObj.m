//
//  YelpObj.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "YelpObj.h"

@implementation YelpObj

- (id)initWithName: (NSString *) name
           address: (NSString *) address
        categories: (NSString *) categories {
    
    self = [super init];
    
    if(self) {
        self.name = name;
        self.address = address;
        self.categories = categories;
    }
    return self;
}

@end
