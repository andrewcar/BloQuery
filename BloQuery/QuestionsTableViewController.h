//
//  QuestionsTableViewController.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/1/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUIConstants.h>

@class QuestionTableViewCell, BFTask, PFObject, PFQuery;

@interface QuestionsTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITextView *composeTextView;

@end
