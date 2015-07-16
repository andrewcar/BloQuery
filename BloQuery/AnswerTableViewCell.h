//
//  AnswerTableViewCell.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/26/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *answerPost;
@property (nonatomic, strong) UIView *answerBox;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIImageView *profilePicImageView;
@property (nonatomic, strong) UILabel *usernameLabel;

+ (CGFloat)heightForAnswerPost:(PFObject *)answerPost withWidth:(CGFloat)width;

@end
