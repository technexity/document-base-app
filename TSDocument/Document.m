//
//  Document.m
//  TSDocument
//
//  Created by Nam Tran on 08/08/2021.
//

#import "Document.h"

@implementation Document

- (id)contentsForType:(NSString*)typeName error:(NSError **)errorPtr {
    // Encode your document with an instance of NSData or NSFileWrapper
    
    if (self.userText == nil) {
        self.userText = @"";
    }
    
    NSData *data = [self.userText dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}
    
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)errorPtr {
    // Load your document from contents
    
    NSData *data = contents;
    self.userText = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return YES;
}

@end
