//
//  NSURLRequest+OAuth.m
//  RoadTrip
//
//  Created by Jaimie Zhu on 7/10/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "NSURLRequest+OAuth.h"
#import "OAMutableURLRequest.h"

/* PATH AND SEARCH CONSTANTS */
static NSString * const kConsumerKey       = @"l-PbInN2UvBsGh98BtGt6w";
static NSString * const kConsumerSecret    = @"i5Q84NXOCnhjhyV5aP5ecSLxgsI";
static NSString * const kToken             = @"hbrYBZbw5aQqyJbDcMbnGYr-Jot97U4Y";
static NSString * const kTokenSecret       = @"DH7-BTBifTUNPKX7JLTgBJ0HDXE";

@implementation NSURLRequest (OAuth)

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path {
    return [self requestWithHost:host path:path params:nil];
}

+ (NSURLRequest *)requestWithHost:(NSString *)host path:(NSString *)path params:(NSDictionary *)params {
    NSURL *URL = [self _URLWithHost:host path:path queryParameters:params];
    
    if ([kConsumerKey length] == 0 || [kConsumerSecret length] == 0 || [kToken length] == 0 || [kTokenSecret length] == 0) {
        NSLog(@"WARNING: Please enter your api v2 credentials before attempting any API request. You can do so in NSURLRequest+OAuth.m");
    }
    
    OAConsumer *consumer = [[OAConsumer alloc] initWithKey:kConsumerKey secret:kConsumerSecret];
    OAToken *token = [[OAToken alloc] initWithKey:kToken secret:kTokenSecret];
    
    //The signature provider is HMAC-SHA1 by default and the nonce and timestamp are generated in the method
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:URL consumer:consumer token:token realm:nil signatureProvider:nil];
    [request setHTTPMethod:@"GET"];
    [request prepare]; // Attaches our consumer and token credentials to the request
    
    return request;
}

// MARK: URL Builder Helper

/*
 Builds an NSURL given a host, path and a number of queryParameters
 
 @param host    The domain host of the API
 @param path    The path of the API after the domain
 @param params  The query parameters
 @return        An NSURL built with the specified parameters
*/
+ (NSURL *)_URLWithHost:(NSString *)host path:(NSString *)path queryParameters:(NSDictionary *)queryParameters {
    
    NSMutableArray *queryParts = [[NSMutableArray alloc] init];
    for (NSString *key in [queryParameters allKeys]) {
        NSString *queryPart = [NSString stringWithFormat:@"%@=%@", key, queryParameters[key]];
        [queryParts addObject:queryPart];
    }
    
    NSURLComponents *components = [[NSURLComponents alloc] init];
    components.scheme = @"http";
    components.host = host;
    components.path = path;
    components.query = [queryParts componentsJoinedByString:@"&"];
    
    return [components URL];
}


@end
