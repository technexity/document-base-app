//
//  DocumentBrowserViewController.m
//  TSDocument
//
//  Created by Nam Tran on 08/08/2021.
//

#import "DocumentBrowserViewController.h"
#import "Document.h"
#import "DocumentViewController.h"
#import "DocumentEditorController.h"
#import "IDAuthenticator.h"

#define DEFAULT_FILE_NAME @"MyDoc.tsdoc"

@interface DocumentBrowserViewController () <UIDocumentBrowserViewControllerDelegate>

@property (assign) BOOL openWithoutAuthentication;

@end

@implementation DocumentBrowserViewController
    
- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.allowsDocumentCreation = YES;
    self.allowsPickingMultipleItems = NO;
    
    // Update the style of the UIDocumentBrowserViewController
    // self.browserUserInterfaceStyle = UIDocumentBrowserUserInterfaceStyleDark;
    // self.view.tintColor = [UIColor whiteColor];
    
    // Specify the allowed content types of your application via the Info.plist.
    
    // Do any additional setup after loading the view.
    self.openWithoutAuthentication = NO;
}

#pragma mark UIDocumentBrowserViewControllerDelegate

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didRequestDocumentCreationWithHandler:(void (^)(NSURL * _Nullable, UIDocumentBrowserImportMode))importHandler {
    
    self.openWithoutAuthentication = YES;
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *fileURL = [fileManager.temporaryDirectory URLByAppendingPathComponent:DEFAULT_FILE_NAME];
    
    Document *document = [[Document alloc] initWithFileURL:fileURL];
    [document saveToURL:fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"There was an error saving the document - %@", fileURL);
        }
        NSLog(@"File created at %@", fileURL);
        
        [document closeWithCompletionHandler:^(BOOL success) {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (!success) {
                    NSLog(@"Failed to close - %@", fileURL);
                }
                
                // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
                // Make sure the importHandler is always called, even if the user cancels the creation request.
                if (fileURL != nil) {
                    importHandler(fileURL, UIDocumentBrowserImportModeMove);
                } else {
                    importHandler(fileURL, UIDocumentBrowserImportModeNone);
                }
                
            });
        }];
        
    }];
}

-(void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)documentURLs {
    NSURL *sourceURL = documentURLs.firstObject;
    if (!sourceURL) {
        return;
    }
    
    // Present the Document View Controller for the first document that was picked.
    // If you support picking multiple items, make sure you handle them all.
    [self presentDocumentAtURL:sourceURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didImportDocumentAtURL:(NSURL *)sourceURL toDestinationURL:(NSURL *)destinationURL {
    
    // Present the Document View Controller for the new newly created document
    [self presentDocumentAtURL:destinationURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller failedToImportDocumentAtURL:(NSURL *)documentURL error:(NSError * _Nullable)error {
    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
}

// MARK: Document Presentation

- (void)presentDocumentAtURL:(NSURL *)documentURL {
    DocumentEditorController *vc = [[DocumentEditorController alloc] init];
    vc.viewController = self;
    vc.document = [[Document alloc] initWithFileURL:documentURL];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if (self.openWithoutAuthentication) {
        [self presentViewController:nav animated:YES completion:^{
            self.openWithoutAuthentication = NO;
        }];
    } else {
        [[IDAuthenticator sharedInstance] authenicateWithCompletionHandler:^(BOOL success, NSString * _Nonnull errorMsg) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:nav animated:YES completion:^{
                        self.openWithoutAuthentication = NO;
                    }];
                });
            }
        }];
    }
}

@end
