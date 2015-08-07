//
//  NSURLRequest+OAuth.h
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURLRequest (OAuth)

/*
 @param host    The domain host
 @param path    The path on the domain host
 @return        Builds NSURLRequest with all the OAuth headers fields set with the host and path given to it
*/
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path;

/*
 @param host    The domain host
 @param path    The path on the domain host
 @return        Builds NSURLRequest with all the OAuth headers field set with the host, path, and query parameters given to it.
*/
+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params;

@end
