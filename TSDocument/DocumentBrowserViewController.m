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

@interface DocumentBrowserViewController () <UIDocumentBrowserViewControllerDelegate>

@property (assign) BOOL isNewDocument;

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
    
    self.isNewDocument = NO;
}

#pragma mark UIDocumentBrowserViewControllerDelegate

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didRequestDocumentCreationWithHandler:(void (^)(NSURL * _Nullable, UIDocumentBrowserImportMode))importHandler {
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSURL *fileURL = [fileManager.temporaryDirectory URLByAppendingPathComponent:@"doc.epd"];
    
    Document *document = [[Document alloc] initWithFileURL:fileURL];
    NSURL *newDocumentURL = document.fileURL;
    self.isNewDocument = YES;
    
    [document saveToURL:newDocumentURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
        if (!success) {
            NSLog(@"There was an error saving the document - %@", newDocumentURL);
        }
        
        NSLog(@"File created at %@", newDocumentURL);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Set the URL for the new document here. Optionally, you can present a template chooser before calling the importHandler.
            // Make sure the importHandler is always called, even if the user cancels the creation request.
            if (newDocumentURL != nil) {
                importHandler(newDocumentURL, UIDocumentBrowserImportModeMove);
            } else {
                importHandler(newDocumentURL, UIDocumentBrowserImportModeNone);
            }
            
        });
    }];
    
    
}

-(void)documentBrowser:(UIDocumentBrowserViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)documentURLs {
    NSURL *sourceURL = documentURLs.firstObject;
    if (!sourceURL) {
        return;
    }
    
    self.isNewDocument = NO;
    
    // Present the Document View Controller for the first document that was picked.
    // If you support picking multiple items, make sure you handle them all.
    [self presentDocumentAtURL:sourceURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller didImportDocumentAtURL:(NSURL *)sourceURL toDestinationURL:(NSURL *)destinationURL {
    
    self.isNewDocument = NO;
    
    // Present the Document View Controller for the new newly created document
    [self presentDocumentAtURL:destinationURL];
}

- (void)documentBrowser:(UIDocumentBrowserViewController *)controller failedToImportDocumentAtURL:(NSURL *)documentURL error:(NSError * _Nullable)error {
    // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
}

// MARK: Document Presentation

- (void)presentDocumentAtURL:(NSURL *)documentURL {
    [self presentDocumentAtURL:documentURL requireAuthenticated:!self.isNewDocument];
}

- (void)presentDocumentAtURL:(NSURL *)documentURL requireAuthenticated:(BOOL)requireAuthenticated {
    DocumentEditorController *vc = [[DocumentEditorController alloc] init];
    vc.viewController = self;
    vc.createNew = NO;
    vc.document = [[Document alloc] initWithFileURL:documentURL];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    if (requireAuthenticated) {
        [[IDAuthenticator sharedInstance] authenicateWithCompletionHandler:^(BOOL success, NSString * _Nonnull errorMsg) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self presentViewController:nav animated:YES completion:nil];
                });
            }
        }];
    } else {
        [self presentViewController:nav animated:YES completion:nil];
    }
}

@end
