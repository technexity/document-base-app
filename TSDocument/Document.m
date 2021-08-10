//
//  Document.m
//  TSDocument
//
//  Created by Nam Tran on 08/08/2021.
//

#import "Document.h"

@implementation Document

- (instancetype)initWithFileURL:(NSURL *)url {
    self = [super initWithFileURL:url];
    if (self) {
        self.text = @"";
    }
    return self;
}

- (id)contentsForType:(NSString*)typeName error:(NSError **)errorPtr {
    // Encode your document with an instance of NSData or NSFileWrapper
    
    NSData *data = [self.text dataUsingEncoding:NSUTF8StringEncoding];
    
    return data;
}
    
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)errorPtr {
    // Load your document from contents
    
    NSData *data = contents;
    self.text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return YES;
}

@end
