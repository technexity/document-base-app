//
//  DocumentEditorController.h
//  TSDocument
//
//  Created by Nam Tran on 07/08/2021.
//

#import <UIKit/UIKit.h>
#import "Document.h"

@class DocumentBrowserViewController;

NS_ASSUME_NONNULL_BEGIN

@interface DocumentEditorController : UIViewController

@property (nonatomic, strong) Document * document;

@property (nonatomic, weak) DocumentBrowserViewController * viewController;

@end

NS_ASSUME_NONNULL_END
