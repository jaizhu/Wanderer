//
//  PlaceObj.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/14/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "PlaceObj.h"

@implementation PlaceObj

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _imageURL = [aDecoder decodeObjectForKey:@"imageURL"];
        _name = [aDecoder decodeObjectForKey:@"name"];
        _location = [aDecoder decodeObjectForKey:@"location"];
        _categories = [aDecoder decodeObjectForKey:@"categories"];
        _yelpURL = [aDecoder decodeObjectForKey:@"yelpURL"];
    }
    return self;
}

// MARK: Encoding and decoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.imageURL forKey:@"imageURL"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.location forKey:@"location"];
    [aCoder encodeObject:self.categories forKey:@"categories"];
    [aCoder encodeObject:self.yelpURL forKey:@"yelpURL"];
}

@end
