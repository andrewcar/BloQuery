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

@end

@implementation AnswersTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        self.tableView.backgroundColor = [UIColor colorWithRed:23/255.0 green:23/255.0 blue:23/255.0 alpha:1];

        self.tableView.separatorColor = [UIColor clearColor];
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
    if (section == 1) {
        return 1;
    } else {
        return 3;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        QuestionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"questionCell" forIndexPath:indexPath];
        cell.questionPost = [DataSource sharedInstance].listOfQuestions[indexPath.row];
        return cell;
    } else {
        AnswerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"answerCell" forIndexPath:indexPath];
        cell.answerPost = [DataSource sharedInstance].listOfAnswers[indexPath.row];
        return cell;
    }

    // Configure the cell...
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *answerPost = [DataSource sharedInstance].listOfAnswers[indexPath.row];
    return [AnswerTableViewCell heightForAnswerPost:answerPost withWidth:CGRectGetWidth(self.view.frame)] + 40;
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
