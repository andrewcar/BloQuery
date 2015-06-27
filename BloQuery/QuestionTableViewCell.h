//
//  QuestionTableViewCell.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/13/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@class QuestionTableViewCell;

@protocol QuestionTableViewCellDelegate <NSObject>

@end

@interface QuestionTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *questionPost;
@property (nonatomic, strong) UIView *questionBox;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, strong) UILabel *numberOfAnswersLabel;

@property (nonatomic, weak) id <QuestionTableViewCellDelegate> delegate;

+ (CGFloat)heightForQuestionPost:(PFObject *)questionPost withWidth:(CGFloat)width;

@end
