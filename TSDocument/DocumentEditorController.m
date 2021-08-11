//
//  DocumentEditorController.m
//  EncryptNote
//
//  Created by Nam Tran on 07/08/2021.
//

#import "DocumentEditorController.h"
#import "DocumentBrowserViewController.h"

#define NUMBER_OF_SECTIONS 3
#define SECTION_NAME 0
#define SECTION_CONTENT 1
#define SECTION_DELETE 2

#define NAME_CONTROL_TAG 100
#define CONTENT_CONTROL_TAG 101

@interface DocumentEditorController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITextField * nameTextField;
@property (nonatomic, strong) UITextView  * contentTextView;

@end

@implementation DocumentEditorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.autoresizesSubviews = YES;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
    
    UIBarButtonItem * cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                                                   target:self action:@selector(cancelAction:)];
    
    UIBarButtonItem * doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                 target:self action:@selector(doneAction:)];
    
    self.navigationItem.leftBarButtonItem = cancelButton;
    self.navigationItem.rightBarButtonItem = doneButton;
    
    //UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //[self.view addGestureRecognizer:tapRecognizer];
}

 - (void)viewWillAppear:(BOOL)animated {
     [super viewWillAppear:animated];
     
     // Access the document
     [self.document openWithCompletionHandler:^(BOOL success) {
         if (success) {
             // Display the content of the document, e.g.:
             self.nameTextField.text = [self.document.fileURL lastPathComponent];
             self.contentTextView.text = self.document.userText;
         } else {
             // Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
         }
     }];
     
 }
     
#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return NUMBER_OF_SECTIONS;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.f;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_CONTENT) {
        return 240.f;
    }
    return 49.f;//UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* CellIdentifier = @"DetailCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.userInteractionEnabled = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        if (indexPath.section == SECTION_NAME) {
            if (indexPath.row == 0) {
                self.nameTextField = [[UITextField alloc] initWithFrame:CGRectZero];
                self.nameTextField.adjustsFontSizeToFitWidth = YES;
                self.nameTextField.backgroundColor = [UIColor whiteColor];
                self.nameTextField.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
                self.nameTextField.autocapitalizationType = UITextAutocapitalizationTypeWords; // no auto capitalization support
                self.nameTextField.textAlignment = NSTextAlignmentLeft;
                self.nameTextField.font = [UIFont systemFontOfSize:20];
                self.nameTextField.tag = NAME_CONTROL_TAG;

                self.nameTextField.keyboardType = UIKeyboardTypeAlphabet; // keyboard type of ur choice
                self.nameTextField.returnKeyType = UIReturnKeyDefault; // returnKey type for keyboard
                self.nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;//UITextFieldViewModeNever;
                
                self.nameTextField.translatesAutoresizingMaskIntoConstraints = NO;
                [cell.contentView addSubview:self.nameTextField];

                [self.nameTextField.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15].active = YES;
                [self.nameTextField.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-12].active = YES;
                [self.nameTextField.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:0].active = YES;
                [self.nameTextField.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:0].active = YES;
                
                self.nameTextField.delegate = self;
            }
        }
        
        if (indexPath.section == SECTION_CONTENT) {
            self.contentTextView = [[UITextView alloc] initWithFrame:CGRectZero];
            
            self.contentTextView.backgroundColor = [UIColor whiteColor];
            self.contentTextView.autocorrectionType = UITextAutocorrectionTypeNo; // no auto correction support
            self.contentTextView.autocapitalizationType = UITextAutocapitalizationTypeSentences; // no auto capitalization support
            self.contentTextView.textAlignment = NSTextAlignmentLeft;
            self.contentTextView.font = [UIFont systemFontOfSize:20];
            self.contentTextView.tag = CONTENT_CONTROL_TAG;
            
            self.contentTextView.keyboardType = UIKeyboardTypeAlphabet; // keyboard type of ur choice
            self.contentTextView.returnKeyType = UIReturnKeyDone; // returnKey type for keyboard
            
            self.contentTextView.translatesAutoresizingMaskIntoConstraints = NO;
            [cell.contentView addSubview:self.contentTextView];
            
            [self.contentTextView.leadingAnchor constraintEqualToAnchor:cell.contentView.leadingAnchor constant:15].active = YES;
            [self.contentTextView.trailingAnchor constraintEqualToAnchor:cell.contentView.trailingAnchor constant:-12].active = YES;
            [self.contentTextView.topAnchor constraintEqualToAnchor:cell.contentView.topAnchor constant:0].active = YES;
            [self.contentTextView.bottomAnchor constraintEqualToAnchor:cell.contentView.bottomAnchor constant:0].active = YES;
            
            self.contentTextView.delegate = self;
        }
        
        if (indexPath.section == SECTION_DELETE) {
            cell.textLabel.font = [UIFont systemFontOfSize:24];
            cell.textLabel.textColor = [UIColor redColor];
            cell.selectionStyle = UITableViewCellSelectionStyleDefault;
        }
    }
    
    if (indexPath.section == SECTION_NAME) {
        if (indexPath.row == 0) {
            //self.nameTextField.text = [self.document.fileURL lastPathComponent];
            //[self.nameTextField becomeFirstResponder];
        }
    }
    
    if (indexPath.section == SECTION_CONTENT) {
        if (indexPath.row == 0) {
            //self.contentTextView.text = self.document.userText;
        }
    }
    
    if (indexPath.section == SECTION_DELETE) {
        cell.textLabel.text = NSLocalizedString(@"Delete Document", nil);
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == SECTION_DELETE) {
#ifdef DEBUG
    NSLog(@"%s", __PRETTY_FUNCTION__);
#endif
        [[self view] endEditing: YES];
        
        UIAlertController* actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil
                                                                      preferredStyle:UIAlertControllerStyleActionSheet];

        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil)
                                                        style:UIAlertActionStyleCancel
                                                      handler:^(UIAlertAction * action) {

            // Cancel button tappped
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }]];

        [actionSheet addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Delete Document", nil)
                                                        style:UIAlertActionStyleDestructive
                                                      handler:^(UIAlertAction * action) {

            // Delete button tapped
            [self dismissViewControllerAnimated:YES completion:^{
                
                //[self.viewController deleteEntry:self.entry];
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            
        }]];
        
        [self presentViewController:actionSheet animated:YES completion:nil];
        
    }
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //[textView becomeFirstResponder];
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [textView resignFirstResponder];
    return YES;
}

#pragma mark -

- (void)tapAction:(UITapGestureRecognizer *)sender {
    [[self view] endEditing: YES];
}

#pragma mark - Actions

- (void)cancelAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)doneAction:(id)sender {
    if ([self.nameTextField.text length] > 0) {
        
    }
    
    self.document.fileName = self.nameTextField.text;
    self.document.userText = self.contentTextView.text;
    
    [self dismissViewControllerAnimated:YES completion:^ {
        
        [self.document saveToURL:[self.document fileURL] forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            [self.document closeWithCompletionHandler:^(BOOL success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if (!success) {
                        NSLog(@"Failed to close - %@", [self.document fileURL]);
                    }
                    
                });
            }];
        }];
        
    }];
}

@end
