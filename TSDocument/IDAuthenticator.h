//
//  IDAuthenticator.h
//  TSDocument
//
//  Created by Nam Tran on 10/08/2021.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IDAuthenticator : NSObject

+ (IDAuthenticator *)sharedInstance;

- (void)authenicateWithCompletionHandler:(void (^)(BOOL success, NSString * errorMsg))completionHandler;

@end

NS_ASSUME_NONNULL_END
