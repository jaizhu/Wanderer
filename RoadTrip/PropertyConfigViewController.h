//
//  PropertyConfigViewController.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/15/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <ParseUI/ParseUI.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface PropertyConfigViewController : UIViewController <PFLogInViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;

@end
