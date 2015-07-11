//
//  AnswersTableViewController.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/16/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "AnswersTableViewController.h"
#import "QuestionTableViewCell.h"
#import "AnswerTableViewCell.h"
#import "DataSource.h"

@interface AnswersTableViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIBarButtonItem *addAnswerButton;
@property (nonatomic, strong) UIView *composeAnswerView;
@property (nonatomic, strong) UILabel *composeTitle;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) NSArray *answers;

@end

@implementation AnswersTableViewController

#define padding 20

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor = [UIColor whiteColor];
        
        self.tableView.separatorColor = [UIColor clearColor];
        
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:25/255.0 green:134/255.0 blue:235/255.0 alpha:1];
        self.navigationController.navigationBar.translucent = NO;
        
        self.refreshControl = [[UIRefreshControl alloc] init];
        self.refreshControl.backgroundColor = [UIColor whiteColor];
        [self.refreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
        
        self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired)];
        
        self.addAnswerButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addAnswer:)];
        self.addAnswerButton.tintColor = [UIColor whiteColor];
        
        self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.submitButton addTarget:self action:@selector(submitFired:) forControlEvents:UIControlEventTouchUpInside];
        self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.cancelButton addTarget:self action:@selector(cancelFired:) forControlEvents:UIControlEventTouchUpInside];

        
        self.navigationItem.rightBarButtonItem = self.addAnswerButton;
        [self.view addGestureRecognizer:self.tap];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[QuestionTableViewCell class] forCellReuseIdentifier:@"questionCell"];
    [self.tableView registerClass:[AnswerTableViewCell class] forCellReuseIdentifier:@"answerCell"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshTable];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0) {
        return 1;
    } else {
        return self.answers.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
        cell.questionPost = self.question;
        cell.numberOfAnswersLabel = nil;
        
        cell.backgroundColor = [UIColor colorWithRed:35/255.0 green:35/255.0 blue:35/255.0 alpha:1];
        
        cell.thoughtBubble1.frame = CGRectMake(CGRectGetMaxX(cell.questionBox.frame) + 11,
                                               CGRectGetMinY(cell.questionBox.frame) + 5,
                                               15,
                                               15);
        cell.thoughtBubble2.frame = CGRectMake(CGRectGetMaxX(cell.thoughtBubble1.frame) + 1,
                                               CGRectGetMinY(cell.thoughtBubble1.frame) + 15,
                                               10,
                                               10);
        cell.thoughtBubble3.frame = CGRectMake(CGRectGetMaxX(cell.thoughtBubble2.frame) - 4,
                                               CGRectGetMinY(cell.thoughtBubble2.frame) + 20,
                                               5,
                                               5);
        cell.faceImageView.frame = CGRectMake(CGRectGetWidth(cell.contentView.frame) - 63,
                                              CGRectGetMaxY(cell.thoughtBubble3.frame) + 5,
                                              53,
                                              53);
        [[DataSource sharedInstance] usernameForAnswer:self.answers[indexPath.row] withSuccess:^(NSArray *user) {
            
        }];
        return cell;
    } else {
        AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
        cell.answerPost = self.answers[indexPath.row];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        PFObject *questionPost = self.question;
        return [QuestionTableViewCell heightForQuestionPost:questionPost withWidth:CGRectGetWidth(self.view.frame)] + 10;
    } else {
        PFObject *answerPost = self.answers[indexPath.row];
        return [AnswerTableViewCell heightForAnswerPost:answerPost withWidth:CGRectGetWidth(self.view.frame)] + 10;
    }
}

#pragma mark - Miscellaneous

- (void)addAnswer:(UIBarButtonItem *)sender {
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7,
                                 CGRectGetHeight(self.view.frame) * 0.4);
    
    if (!self.composeAnswerView || self.composeAnswerView.frame.origin.y < 0) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            
            // move scroll view to top
            [self.tableView setContentOffset:CGPointMake(0, -self.tableView.contentInset.top) animated:YES];
            
            // align view to center and above screen
            self.composeAnswerView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                                                CGRectGetMinY(self.view.frame) * -2,
                                                                                viewSize.width,
                                                                                viewSize.height)];
            
            // bring down to screen's center y
            self.composeAnswerView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                        CGRectGetMaxY(self.navigationController.navigationBar.frame) + 10,
                                                        viewSize.width,
                                                        viewSize.height);
            self.composeAnswerView.backgroundColor = [UIColor whiteColor];
            
            self.composeTitle = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          5,
                                                                          viewSize.width,
                                                                          37)];
            self.composeTitle.text = @"Write your question";
            self.composeTitle.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.composeTitle.textAlignment = NSTextAlignmentCenter;
            
            self.composeTextView = [[UITextView alloc] initWithFrame:CGRectMake(5,
                                                                                CGRectGetMaxY(self.composeTitle.frame) + 5,
                                                                                CGRectGetWidth(self.composeAnswerView.frame) - 10,
                                                                                CGRectGetHeight(self.composeAnswerView.frame) -
                                                                                CGRectGetHeight(self.composeTitle.frame) - 10)];
            self.composeTextView.backgroundColor = [UIColor whiteColor];
            self.composeTextView.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.composeTextView.returnKeyType = UIReturnKeyDefault;
            self.composeTextView.keyboardAppearance = UIKeyboardAppearanceDark;
            
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeAnswerView.frame),
                                                 CGRectGetMaxY(self.composeAnswerView.frame),
                                                 viewSize.width / 2,
                                                 0);
            [self.cancelButton addTarget:self action:@selector(cancelFired:) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.backgroundColor = [UIColor darkGrayColor];
            self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
            self.submitButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:27/255.0 alpha:1];
            self.submitButton.titleLabel.textColor = [UIColor whiteColor];
            self.submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.submitButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            [self.view addSubview:self.composeAnswerView];
            [self.composeAnswerView addSubview:self.composeTitle];
            [self.composeAnswerView addSubview:self.composeTextView];
            [self.view addSubview:self.cancelButton];
            [self.view addSubview:self.submitButton];
        } completion:^(BOOL finished) {
            
            [self.composeTextView becomeFirstResponder];
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeAnswerView.frame),
                                                     CGRectGetMaxY(self.composeAnswerView.frame),
                                                     viewSize.width / 2,
                                                     37);
                self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                     CGRectGetMaxY(self.composeAnswerView.frame),
                                                     viewSize.width / 2,
                                                     37);
                
            } completion:^(BOOL finished) {
                [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
                [self.submitButton setTitle:@"submit" forState:UIControlStateNormal];
                
                self.tableView.allowsSelection = NO;
            }];
        }];
    }
}

- (void)submitFired:(UIButton *)sender {
    self.tableView.allowsSelection = YES;
    
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    // animate button press
    [UIView animateWithDuration:.1 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.composeAnswerView.frame),
                                             (viewSize.width / 2),
                                             80);
    }];
    [UIView animateWithDuration:.42 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.composeAnswerView.frame),
                                             viewSize.width / 2,
                                             37);
    }];
    
    // submit to parse for current user
    [[DataSource sharedInstance] postAnswer:self.composeTextView.text withSuccess:^(BOOL succeeded) {
        [self refreshTable];
        NSLog(@"%@", self.composeTextView.text);
    }];
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeAnswerView.frame),
                                             CGRectGetMaxY(self.composeAnswerView.frame),
                                             viewSize.width / 2,
                                             0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.composeAnswerView.frame),
                                             viewSize.width / 2,
                                             0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.composeAnswerView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                        CGRectGetMinY(self.view.frame) - 1000,
                                                        viewSize.width,
                                                        viewSize.height);
            self.composeTitle.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                 CGRectGetMaxY(self.composeAnswerView.frame),
                                                 viewSize.width / 2,
                                                 0);
            self.composeTextView.frame = CGRectMake(5,
                                                    CGRectGetMinY(self.view.frame) * -2,
                                                    CGRectGetWidth(self.composeAnswerView.frame) - 10,
                                                    CGRectGetHeight(self.composeAnswerView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
    
    //clear out text view, hide keyboard, and refresh table
    self.composeTextView.text = @"";
    [self.composeTextView resignFirstResponder];
}

- (void)cancelFired:(UIButton *)sender {
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeAnswerView.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.composeAnswerView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.view.frame) - 1000, viewSize.width, viewSize.height);
            self.composeTitle.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
            self.composeTextView.frame = CGRectMake(5, CGRectGetMinY(self.view.frame) * -2, CGRectGetWidth(self.composeAnswerView.frame) - 10, CGRectGetHeight(self.composeAnswerView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
}

- (void)tapFired {
    [self.composeTextView resignFirstResponder];
    
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.composeAnswerView.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.composeAnswerView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.navigationController.navigationBar.frame) - 1000, viewSize.width, viewSize.height);
            self.composeTitle.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.composeAnswerView.frame), viewSize.width / 2, 0);
            self.composeTextView.frame = CGRectMake(5, CGRectGetMinY(self.view.frame) * -2, CGRectGetWidth(self.composeAnswerView.frame) - 10, CGRectGetHeight(self.composeAnswerView.frame) - CGRectGetHeight(self.composeTitle.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
}

- (void)refreshTable {
    [self.tableView reloadData];
    [[DataSource sharedInstance] answersForQuestion:self.question withSuccess:^(NSArray *answers) {
        self.answers = answers;
        [self.tableView reloadData];
        NSString *title = @"Loading";
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjects:@[[UIColor whiteColor], [UIFont fontWithName:@"STHeitiSC-Medium" size:19]] forKeys:@[NSForegroundColorAttributeName, NSFontAttributeName]];
        NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attributesDictionary];
        self.refreshControl.attributedTitle = attributedTitle;
    }];
    AnswerTableViewCell *cell = [[AnswerTableViewCell alloc] init];
    [[DataSource sharedInstance] usernameForAnswer:cell.answerPost withSuccess:^(NSArray *user) {
        cell.usernameLabel.text = [user lastObject][@"username"];
    }];
    [self.refreshControl endRefreshing];
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
