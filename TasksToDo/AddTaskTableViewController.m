//
//  AddTaskTableViewController.m
//  TasksToDo
//
//  Created by Prabhu.S on 24/01/16.
//  Copyright © 2016 Prabhu.S. All rights reserved.
//

#import "AddTaskTableViewController.h"
#import "DateConverter.h"
#import "DataModelExtensions.h"

#define kFontSize 13.0 // fontsize
#define kTextViewWidth 430 // from storyboard
#define kDateTimeFormat @"yyyy-MM-dd HH:mm"

@interface AddTaskTableViewController () <UITextViewDelegate, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate> {
    UIDatePicker *datePicker;
    NSDate *date;
    UIToolbar *keyboardToolbar;
    UIPickerView *picker;
}
@property (nonatomic, strong)newTaskCallBack insertCallBack;
@property (nonatomic, strong)deleteTaskCallBack removeCallBack;
@property (nonatomic, strong)updateTaskCallBack updateCallBack;
@property (weak, nonatomic) IBOutlet UITextField *subjectTextField;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *priorityTextField;
@property (weak, nonatomic) IBOutlet UITextField *categoryTextField;
@property (weak, nonatomic) IBOutlet UIButton *btnSave;
@property (copy, nonatomic) NSString *dateSelectedInDatePicker;
@property (assign, nonatomic) NSInteger prioritySelectedInPicker;
@property (strong, nonatomic) NSArray *priorities;
@property (weak, nonatomic) IBOutlet UILabel *markAsCompleteLabel;
@property (weak, nonatomic) IBOutlet UISwitch *markAsCompleteSwitch;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeightConstraint;
@end

@implementation AddTaskTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.taskItem) {
        [self.subjectTextField becomeFirstResponder];
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
    }

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(dismissKeyboard)];

    [self.view addGestureRecognizer:tap];
    
    self.textView.delegate = self;
    self.dateTextField.delegate = self;
    self.categoryTextField.delegate = self;
    self.priorityTextField.delegate = self;
    
    [self setupDatepickerToolbar];
    self.dateTextField.inputAccessoryView = keyboardToolbar;

    // date picker
    datePicker = [[UIDatePicker alloc] init];
    datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.dateTextField.inputView = datePicker;
    self.dateSelectedInDatePicker = [DateConverter stringFromDate:[NSDate date] withFormat:kDateTimeFormat];
    self.dateTextField.text = self.dateSelectedInDatePicker;
    
    // picker view
    [self createPicker];
    self.priorityTextField.inputView = picker;
    self.prioritySelectedInPicker = 3; // setting default priority to normal
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.editing  = (_displayMode != ViewMode);
    
    if (self.taskItem) {
        self.subjectTextField.text = [self.taskItem valueForKey:@"taskSubject"];
        self.textViewContent = [self.taskItem valueForKey:@"taskDetail"];
        self.textView.text = self.textViewContent;
        NSString *dateInString =
            [DateConverter stringFromDate:[self.taskItem valueForKey:@"createdDate"] withFormat:kDateTimeFormat];
        self.dateTextField.text = dateInString;
        self.priorityTextField.text = priorityIntToString([[self.taskItem valueForKey:@"priority"] intValue]);
        self.categoryTextField.text = [self.taskItem valueForKey:@"categoryName"];
    }
    else {
        self.navigationItem.title = @"New Task";
        self.btnSave.enabled = NO;
        //Size task description to something that is form fitting to the string in the model.
        self.textViewContent = @"";
    }

    // height of text view is calculated
    float height = [self textViewheight:self.textView withString:self.textViewContent];
    CGRect textViewRect = CGRectMake(74, 4, kTextViewWidth, height);
    self.textView.frame = textViewRect;
    
    // to get proper contentSize dimensions
    self.textView.contentSize =
        CGSizeMake(kTextViewWidth, [self textViewheight:self.textView withString:self.textViewContent]);
    
    self.textView.text = self.textViewContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.toolbarHidden = NO;
}

- (CGFloat)textViewheight:(UITextView*)textView withString:(NSString*)string {
    float horizontalPadding = 20.0f;
    float verticalPadding = 16.0f;
    float widthOfTextView = textView.contentSize.width - horizontalPadding;
    UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:kFontSize];
    NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:string
                                        attributes:@{NSFontAttributeName: font}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){widthOfTextView, CGFLOAT_MAX}
                                               options:NSStringDrawingUsesLineFragmentOrigin
                                               context:nil];
    self.textViewHeightConstraint.constant = rect.size.height + verticalPadding;
    return rect.size.height + verticalPadding;
}

#pragma mark - Edit vs No Editable View State

- (void)setEditing:(BOOL)editing {
    [super setEditing:editing];
    
    self.subjectTextField.enabled = editing;
    self.textView.userInteractionEnabled = editing;
    self.dateTextField.enabled  = editing;
    self.priorityTextField.enabled = editing;
    self.categoryTextField.enabled = editing;
    //hide save action
    self.btnSave.hidden = !editing;
    if (_displayMode == EditMode && editing) {
        self.navigationController.toolbarHidden = false;
        self.btnSave.hidden = false;
    }
    else {
        self.navigationController.toolbarHidden = true;
    }
    //hide complete switch
    self.markAsCompleteLabel.hidden = !editing;
    self.markAsCompleteSwitch.hidden = !editing;
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        if (self.textView.contentSize.height >= 33) {
            float height = [self textViewheight:self.textView withString:self.textViewContent];
            return height + 12; // a little extra padding is needed
        }
        else {
            return self.tableView.rowHeight;
        }
        
    }
    else {
        return self.tableView.rowHeight;
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

#pragma mark - UITextViewDelegate

- (void) textViewDidChange:(UITextView *)textView {
    self.textViewContent = textView.text;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
}

- (void) textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.textView) {
        self.textViewContent = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *strContent = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSString *strSubject = self.textView.text;
    
    strSubject = [strSubject stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    strContent = [strContent stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    [self validateField:strSubject description:strContent];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    return YES;
}

#pragma mark - UIPickerViewDataSource

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *returnStr = @"";

    if (pickerView == picker) {
        if (component == 0) {
            returnStr = [self.priorities objectAtIndex:row];
        }
    }

    return returnStr;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.priorities count];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

#pragma mark - UIPickerViewDelegate

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.prioritySelectedInPicker = row;
    self.priorityTextField.text = priorityIntToString(self.prioritySelectedInPicker);
}

#pragma mark - Action methods

- (IBAction)saveTask:(id)sender {
    NSString *subject =
        [self.subjectTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *description =
        [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    if (subject.length < 1) {
        return;
    }
    
    if (self.taskItem) {
        //Update the task
        [self.navigationController popViewControllerAnimated:YES];
        NSString *uniqueTaskID = [self.taskItem valueForKey:@"taskID"];
        NSDictionary *task =  @{@"taskID" : uniqueTaskID,
                                @"taskSubject" : subject,
                                @"taskDetail" : description,
                                @"createdDate" : [DateConverter dateFromString:self.dateSelectedInDatePicker withFormat:kDateTimeFormat],
                                @"categoryName" : self.categoryTextField.text,
                                @"priority" : [NSNumber numberWithInteger:self.prioritySelectedInPicker]
                                };
        self.updateCallBack(task, uniqueTaskID);
    }
    else {
        // Insert new task
        int r = arc4random_uniform(74);
        NSDictionary *task =  @{@"taskID" : [NSString stringWithFormat:@"%d", r],
                                @"taskSubject" : subject,
                                @"taskDetail" : description,
                                @"createdDate" : [DateConverter dateFromString:self.dateSelectedInDatePicker withFormat:kDateTimeFormat],
                                @"categoryName" : self.categoryTextField.text,
                                @"priority" : [NSNumber numberWithInteger:self.prioritySelectedInPicker]
                                };
        self.insertCallBack(task);
        [self.navigationController popViewControllerAnimated:YES];
    }
}


- (IBAction)deleteTask:(id)sender {
    NSString *taskIdString = [self.taskItem valueForKey:@"taskID"];
    self.removeCallBack(taskIdString);
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}


- (IBAction)editTask:(id)sender {
    self.editing = YES;
    self.btnSave.enabled = YES;
    [self.subjectTextField becomeFirstResponder];
}


#pragma mark - Callback Method

- (void)newTaskCallBack:(newTaskCallBack)callback {
    self.insertCallBack = callback;
}

- (void)deleteTaskCallBack:(deleteTaskCallBack)callback {
    self.removeCallBack = callback;
}

- (void)updateTaskCallBack:(updateTaskCallBack)callback {
    self.updateCallBack = callback;
}

#pragma mark - Private Methods

- (void)setupDatepickerToolbar {
    if (keyboardToolbar == nil) {
        keyboardToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
        [keyboardToolbar setBarStyle:UIBarStyleBlackTranslucent];

        UIBarButtonItem *extraSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

        UIBarButtonItem *accept =
            [[UIBarButtonItem alloc] initWithTitle:@"Accept"
                                             style:UIBarButtonItemStyleDone
                                            target:self
                                            action:@selector(dismissKeyboard)];

        [keyboardToolbar setItems:[[NSArray alloc] initWithObjects: extraSpace, accept, nil]];
    }
}

- (void)validateField:(NSString *)strSubject description:(NSString*)strContent {
    if (strSubject.length && strContent.length) {
        self.btnSave.enabled = YES;
        self.btnSave.tintColor = [UIColor greenColor];
    }
    else {
        self.btnSave.enabled = NO;
        self.btnSave.tintColor = [UIColor grayColor];
    }
}

-(void)dismissKeyboard {
    [self.view endEditing:YES];
}

- (void)datePickerValueChanged:(id)sender {
    date = datePicker.date;

    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:kDateTimeFormat];

    self.dateTextField.text = [df stringFromDate:date];
}

- (void)createPicker {
    self.priorities = @[@"High", @"Medium", @"Low"];
    if (picker == nil) {
        picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
        picker.showsSelectionIndicator = YES; // default is NO
        picker.delegate = self;
        picker.dataSource = self;
    }
}

@end
