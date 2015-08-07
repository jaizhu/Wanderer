//
//  YelpObj.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YelpObj : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *categories;

- (id)initWithName: (NSString *) name
           address: (NSString *) address
        categories: (NSString *) categories;

@end
