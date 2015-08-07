//
//  LoginViewController.h
//  RoadTrip
//
//  Created by Sophia Raji on 7/9/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseFacebookUtilsV4/PFFacebookUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface LoginViewController : UIViewController <UITextFieldDelegate, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

@end