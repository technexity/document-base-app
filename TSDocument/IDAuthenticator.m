//
//  IDAuthenticator.m
//  TSDocument
//
//  Created by Nam Tran on 10/08/2021.
//

#import <LocalAuthentication/LocalAuthentication.h>
#import "IDAuthenticator.h"

@implementation IDAuthenticator

+ (IDAuthenticator *)sharedInstance {
    static IDAuthenticator *_sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        _sharedInstance = [[IDAuthenticator alloc] init];
    });
    return _sharedInstance;
}

- (void)authenicateWithCompletionHandler:(void (^)(BOOL success, NSString * errorMsg))completionHandler {

    LAContext *context = [[LAContext alloc] init];
    NSError *authError = nil;

    /// Test if fingerprint authentication is available on the device and a fingerprint has been enrolled.

    NSString *localizedReason = @"Please authenticate using your fingerprint.";

    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&authError]) {

        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
               localizedReason:localizedReason reply:^(BOOL success, NSError *error) {
           
            if (success) {
                NSLog(@"User authenticated successfully, take appropriate action");
               
                // User authenticated successfully, take appropriate action
                completionHandler(YES, nil);
            }
            else {
                NSLog(@"User did not authenticate successfully, look at error and take appropriate action");
               
                NSString * errorMessage = nil;
               
                switch (error.code) {
                case LAErrorAuthenticationFailed:
                    errorMessage = @"There was a problem verifying your identity.";
                    break;
                case LAErrorUserCancel:
                    NSLog(@"user has tapped the home button and authentication is canced by user");

                    errorMessage = @"You pressed cancel.";
                    break;
                case LAErrorUserFallback:
                    errorMessage = @"You pressed password.";
                    break;
                case LAErrorBiometryNotAvailable:
                    errorMessage = @"Face ID/Touch ID is not available.";
                    break;
                case LAErrorBiometryNotEnrolled:
                    errorMessage = @"Face ID/Touch ID is not set up.";
                    break;
                case LAErrorBiometryLockout:
                    NSLog(@"Authentication was not successful because there were too many failed biometry attempts (5 consequitive attempts) and biometry is now locked.Passcode is required to unlock biometry");

                    errorMessage = @"Face ID/Touch ID is locked.";
                    break;
                default:
                    errorMessage = @"Face ID/Touch ID may not be configured";
                }
               
                completionHandler(NO, errorMessage);
           }
       }];
    }
    else {
        if (authError.code) {
            NSLog(@"There is no need to handle evaluate policy auth error as user is already handled the policy evaluated error in app delegate if user is not handling the policy evaluated error in app delegate then handle the auth error here.");
        }
        
        completionHandler(NO, authError.localizedDescription);
    }
}

@end
