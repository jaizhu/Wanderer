//
//  PropertyConfigViewController.m
//  RoadTrip
//
//  Created by Sophia Raji on 7/15/15.
//  Copyright (c) 2015 fBomb. All rights reserved.
//

#import "PropertyConfigViewController.h"

@implementation PropertyConfigViewController

#pragma mark - UIViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([PFUser currentUser]) {
        // If the user is logged in, show their name in the welcome label.
        
        if ([PFTwitterUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Twitter, we'll use their Twitter screen name
            self.lblUsername.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome @%@!", nil), [PFTwitterUtils twitter].screenName];
            
        } else if ([PFFacebookUtils isLinkedWithUser:[PFUser currentUser]]) {
            // If user is linked to Facebook, we'll use the Facebook Graph API to fetch their full name. But first, show a generic Welcome label.
            self.lblUsername.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome!", nil)];
            
            // Create Facebook Request for user's details
            FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                           parameters:nil];
            [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                // This is an asynchronous method. When Facebook responds, if there are no errors, we'll update the Welcome label.
                if (!error) {
                    NSString *displayName = result[@"name"];
                    if (displayName) {
                        self.lblUsername.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), displayName];
                    }
                }
            }];
            
        } else {
            // If user is linked to neither, let's use their username for the Welcome label.
            self.lblUsername.text =[NSString stringWithFormat:NSLocalizedString(@"Welcome %@!", nil), [PFUser currentUser].username];
            
        }
        
    } else {
        self.lblUsername.text = NSLocalizedString(@"Not logged in", nil);
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // Check if user is logged in
    if (![PFUser currentUser]) {
        // If not logged in, we will show a PFLogInViewController
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        
        // Customize the Log In View Controller
        logInViewController.delegate = self;
        logInViewController.facebookPermissions = @[@"friends_about_me"];
        logInViewController.fields = PFLogInFieldsTwitter | PFLogInFieldsFacebook | PFLogInFieldsDismissButton; // Show Twitter login, Facebook login, and a Dismiss button.
        
        // Present Log In View Controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
    }
}

#pragma mark - PFLogInViewControllerDelegate

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    [self dismissViewControllerAnimated:YES completion:NULL];
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"Failed to log in...");
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    NSLog(@"User dismissed the logInViewController");
}

@end
