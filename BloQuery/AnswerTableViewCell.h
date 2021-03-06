//
//  AnswerTableViewCell.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/26/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;

@protocol AnswerTableViewCellDelegate <NSObject>

- (void)didTapProfilePicOnAnswer:(PFObject *)answerPost;
- (void)didToggleLikeOnAnswer:(PFObject *)answerPost;

@end

@interface AnswerTableViewCell : UITableViewCell

@property (nonatomic, strong) PFObject *answerPost;
@property (nonatomic, strong) UIView *answerBox;
@property (nonatomic, strong) UILabel *answerLabel;
@property (nonatomic, strong) UIImageView *profilePicImageView;
@property (nonatomic, strong) UIButton *profileButton;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UIButton *likeButton;
@property (nonatomic, weak) id <AnswerTableViewCellDelegate> delegate;

+ (CGFloat)heightForAnswerPost:(PFObject *)answerPost withWidth:(CGFloat)width;

@end
