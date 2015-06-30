//
//  AnswerTableViewCell.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/26/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse/Parse.h"

@class AnswerTableViewCell;

@protocol AnswerTableViewCellDelegate <NSObject>

@end

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *answerPost;
@property (nonatomic, strong) UIView *answerBox;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIImageView *faceImageView;
@property (nonatomic, weak) id <AnswerTableViewCellDelegate> delegate;

+ (CGFloat)heightForAnswerPost:(PFObject *)answerPost withWidth:(CGFloat)width;

@end
