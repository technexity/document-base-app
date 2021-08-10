//
//  DocumentBrowserViewController.h
//  TSDocument
//
//  Created by Nam Tran on 08/08/2021.
//

#import <UIKit/UIKit.h>

@interface DocumentBrowserViewController : UIDocumentBrowserViewController

- (void)presentDocumentAtURL:(NSURL *)documentURL;

@end
