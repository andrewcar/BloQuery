//
//  AnswersTableViewController.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/16/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"
#import "QuestionTableViewCell.h"
#import "AnswerTableViewCell.h"

@interface AnswersTableViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, QuestionTableViewCellDelegate, AnswerTableViewCellDelegate>

@property (nonatomic, strong) UITextView *composeTextView;
@property (nonatomic, strong) PFObject *question;

@end
