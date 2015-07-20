//
//  QuestionTableViewCell.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/13/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@protocol QuestionTableViewCellDelegate <NSObject>

- (void)didTapProfilePicOnQuestion:(PFObject *)questionPost;

@end

@interface QuestionTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *questionPost;
@property (nonatomic, strong) UIView *questionBox;
@property (nonatomic, strong) UILabel *questionLabel;
@property (nonatomic, strong) UIImageView *profilePicImageView;
@property (nonatomic, strong) UILabel *numberOfAnswersLabel;
@property (nonatomic, strong) UIView *thoughtBubble1;
@property (nonatomic, strong) UIView *thoughtBubble2;
@property (nonatomic, strong) UIView *thoughtBubble3;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, weak) id <QuestionTableViewCellDelegate> delegate;

+ (CGFloat)heightForQuestionPost:(PFObject *)questionPost withWidth:(CGFloat)width;

@end
