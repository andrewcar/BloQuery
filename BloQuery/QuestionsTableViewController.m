//
//  QuestionsTableViewController.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/1/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "QuestionsTableViewController.h"
#import "QuestionTableViewCell.h"
#import "AnswersTableViewController.h"
#import "DataSource.h"

@interface QuestionsTableViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIBarButtonItem *addQuestionButton;
@property (nonatomic, strong) UIView *composeQuestionView;
@property (nonatomic, strong) UILabel *composeTitle;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation QuestionsTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.1 green:0.55 blue:0.69 alpha:1];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"questionCell"];
    
    self.tableView.separatorColor = [UIColor clearColor];
    
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired)];
    
    self.addQuestionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addQuestion:)];
    self.addQuestionButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = self.addQuestionButton;
    
    [self.view addGestureRecognizer:self.tap];
    
    [[DataSource sharedInstance] populateListOfQuestions:^(NSArray *questions) {
        [self.tableView reloadData];
    }];
        
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [DataSource sharedInstance].listOfQuestions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
    cell.questionPost = [DataSource sharedInstance].listOfQuestions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *questionPost = [DataSource sharedInstance].listOfQuestions[indexPath.row];
    return [QuestionTableViewCell heightForQuestionPost:questionPost withWidth:CGRectGetWidth(self.view.frame)] + 40;
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UINavigationController *navVC = [[UINavigationController alloc] init];
    [self presentViewController:navVC animated:YES completion:nil];
    AnswersTableViewController *answersVC = [[AnswersTableViewController alloc] init];
    [navVC setViewControllers:@[answersVC] animated:NO];
}

#pragma mark - Miscellaneous

- (void)addQuestion:(UIBarButtonItem *)sender {
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);

    if ((!self.composeQuestionView) || self.composeQuestionView.frame.size.height > 0) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            
            // move scroll view to top
            [self.tableView setContentOffset:CGPointZero animated:YES];
            
            // align view to center and above screen
            self.composeQuestionView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.view.frame) * -2, viewSize.width, viewSize.height)];
            
            // bring down to screen's center y
            self.composeQuestionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMidY(self.view.frame) - viewSize.height, viewSize.width, viewSize.height);
            self.composeQuestionView.backgroundColor = [UIColor whiteColor];
            
            self.composeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 5, viewSize.width, 37)];
            self.composeTitle.text = @"write your question";
            self.composeTitle.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.composeTitle.textAlignment = NSTextAlignmentCenter;
            
            self.composeTextView = [[UITextView alloc] initWithFrame:CGRectMake(5, CGRectGetMaxY(self.composeTitle.frame) + 5, CGRectGetWidth(self.composeQuestionView.frame) - 10, CGRectGetHeight(self.composeQuestionView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10)];
            self.composeTextView.backgroundColor = [UIColor whiteColor];
            self.composeTextView.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeQuestionView.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
            [self.cancelButton addTarget:self action:@selector(cancelFired:) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.backgroundColor = [UIColor grayColor];
            self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
            [self.submitButton addTarget:self action:@selector(submitFired:) forControlEvents:UIControlEventTouchUpInside];
            self.submitButton.backgroundColor = [UIColor colorWithRed:0.989 green:0.199 blue:0.233 alpha:1];
            self.submitButton.titleLabel.textColor = [UIColor whiteColor];
            self.submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.submitButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            [self.view addSubview:self.composeQuestionView];
            [self.composeQuestionView addSubview:self.composeTitle];
            [self.composeQuestionView addSubview:self.composeTextView];
            [self.view addSubview:self.cancelButton];
            [self.view addSubview:self.submitButton];
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeQuestionView.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 37);
                self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 37);

            } completion:^(BOOL finished) {
                [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
                [self.submitButton setTitle:@"submit" forState:UIControlStateNormal];
                
                self.tableView.allowsSelection = NO;
                NSLog(@"composeQuestionView Min X: %f  Min Y: %f", CGRectGetMinX(self.composeQuestionView.frame), CGRectGetMinY(self.composeQuestionView.frame));
                NSLog(@"composeQuestionView Max X: %f  Max Y: %f", CGRectGetMaxX(self.composeQuestionView.frame), CGRectGetMaxY(self.composeQuestionView.frame));
                NSLog(@"composeTextView Min X: %f  Min Y: %f", CGRectGetMinX(self.composeTextView.frame), CGRectGetMinY(self.composeTextView.frame));
                NSLog(@"composeTextView Max X: %f  Max Y: %f", CGRectGetMaxX(self.composeTextView.frame), CGRectGetMaxY(self.composeTextView.frame));
                NSLog(@"cancelButton Min X: %f  Min Y: %f", CGRectGetMinX(self.cancelButton.frame), CGRectGetMinY(self.cancelButton.frame));
                NSLog(@"cancelButton Max X: %f  Max Y: %f", CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.cancelButton.frame));
                NSLog(@"submitButton Min X: %f  Min Y: %f", CGRectGetMinX(self.submitButton.frame), CGRectGetMinY(self.submitButton.frame));
                NSLog(@"submitButton Max X: %f  Max Y: %f", CGRectGetMaxX(self.submitButton.frame), CGRectGetMaxY(self.submitButton.frame));
            }];
        }];
    }
}

- (void)tapFired {
    [self.composeTextView resignFirstResponder];
}

- (void)submitFired:(UIButton *)sender {
    NSLog(@"submit fired");
    self.tableView.allowsSelection = YES;
    
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    // animate button press
    [UIView animateWithDuration:.1 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), (viewSize.width / 2) + 21, 45);
        self.submitButton.backgroundColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
    }];
    [UIView animateWithDuration:.42 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 37);
    }];
    
    // submit to parse for current user
    [[DataSource sharedInstance] postQuestion:self.composeTextView.text];
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeQuestionView.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.composeQuestionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.view.frame) * -10, viewSize.width, viewSize.height);
            self.composeTitle.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
            self.composeTextView.frame = CGRectMake(5, CGRectGetMinY(self.view.frame) * -2, CGRectGetWidth(self.composeQuestionView.frame) - 10, CGRectGetHeight(self.composeQuestionView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
    
    //clear out text view
    self.composeTextView.text = @"";
}

- (void)cancelFired:(UIButton *)sender {
    NSLog(@"cancel fired");
    self.tableView.allowsSelection = YES;

    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeQuestionView.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.composeQuestionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.view.frame) * -10, viewSize.width, viewSize.height);
            self.composeTitle.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeQuestionView.frame), viewSize.width / 2, 0);
            self.composeTextView.frame = CGRectMake(5, CGRectGetMinY(self.view.frame) * -2, CGRectGetWidth(self.composeQuestionView.frame) - 10, CGRectGetHeight(self.composeQuestionView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
