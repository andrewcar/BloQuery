//
//  AnswerTableViewCell.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/26/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "AnswerTableViewCell.h"
#import <Parse/Parse.h>
#import "DataSource.h"

@implementation AnswerTableViewCell

#define padding 20

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        self.answerBox = [[UIView alloc] init];
        self.answerBox.backgroundColor = [UIColor colorWithRed:25/255.0 green:134/255.0 blue:235/255.0 alpha:1];

        self.answerLabel = [[UILabel alloc] init];
        self.answerLabel.backgroundColor = [UIColor clearColor];
        self.answerLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.answerLabel.textColor = [UIColor whiteColor];
        self.answerLabel.textAlignment = NSTextAlignmentLeft;
        self.answerLabel.numberOfLines = 0;
        
        self.profilePicImageView = [[UIImageView alloc] init];
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.profileButton addTarget:self action:@selector(profileButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];

        self.likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.likeButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        [self.likeButton addTarget:self action:@selector(likeButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        self.likeButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.likeButton.titleLabel.textColor = [UIColor whiteColor];
        self.likeButton.titleLabel.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:self.answerBox];
        [self.contentView addSubview:self.answerLabel];
        [self.contentView addSubview:self.profilePicImageView];
        [self.contentView addSubview:self.profileButton];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.likeButton];
    }
    return self;
}

- (void)setAnswerPost:(PFObject *)answerPost {
    _answerPost = answerPost;
    self.answerLabel.text = answerPost[@"text"];
    [[DataSource sharedInstance] usernameForAnswer:_answerPost withSuccess:^(NSArray *user) {
        self.usernameLabel.text = [user lastObject][@"username"];
        PFFile *imageFile = [user lastObject][@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.profilePicImageView.image = [UIImage imageWithData:data];
        }];
    }];
    [[DataSource sharedInstance] likesForAnswer:self.answerPost withSuccess:^(NSArray *likes) {
        if (likes) {
            if (likes.count < 1) {
                NSLog(@"no likes");
            } else if (likes.count == 1) {
                [self.likeButton setTitle:[NSString stringWithFormat:@"%lu like", (unsigned long)likes.count] forState:UIControlStateNormal];
            } else {
                [self.likeButton setTitle:[NSString stringWithFormat:@"%lu likes", (unsigned long)likes.count] forState:UIControlStateNormal];
            }
        } else {
            NSLog(@"like request failed");
        }
    }];
}

- (void)layoutSubviews {
    CGSize maxSizeForAnswerLabel = CGSizeMake(CGRectGetWidth(self.contentView.frame) * 0.72,
                                                CGFLOAT_MAX);
    CGSize answerLabelSize = [self.answerLabel sizeThatFits:maxSizeForAnswerLabel];
    self.answerLabel.frame = CGRectMake(padding * 2,
                                          padding * 2,
                                          answerLabelSize.width,
                                          answerLabelSize.height);
    self.answerBox.frame = CGRectMake(padding,
                                        padding,
                                        (CGRectGetWidth(self.contentView.frame) * 0.72) + (padding * 2),
                                        answerLabelSize.height + (padding * 2));
    self.profilePicImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 63,
                                          CGRectGetMaxY(self.answerBox.frame) - 33,
                                          53,
                                          53);
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height / M_PI;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;

    self.profileButton.frame = CGRectMake(CGRectGetMinX(self.profilePicImageView.frame), CGRectGetMinY(self.profilePicImageView.frame), CGRectGetWidth(self.profilePicImageView.frame), CGRectGetHeight(self.profilePicImageView.frame));

    CGSize maxSizeForUsernameLabel = CGSizeMake(CGRectGetWidth(self.answerBox.frame),
                                                       69);
    CGSize usernameLabelSize = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
    self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.answerBox.frame) - usernameLabelSize.width / 2,
                                                 CGRectGetMaxY(self.answerBox.frame) + padding,
                                                 usernameLabelSize.width + padding,
                                                 usernameLabelSize.height + padding);
    CGSize maxSizeForLikeButton = CGSizeMake(CGFLOAT_MAX, 69);
    CGSize sizeForLikeButton = [self.likeButton sizeThatFits:maxSizeForLikeButton];
    self.likeButton.frame = CGRectMake(CGRectGetMinX(self.answerBox.frame),
                                       CGRectGetMaxY(self.answerBox.frame) + padding,
                                       sizeForLikeButton.width + padding,
                                       sizeForLikeButton.height);
}

+ (CGFloat)heightForAnswerPost:(PFObject *)answerPost withWidth:(CGFloat)width {
    // Make a cell
    AnswerTableViewCell *layoutCell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    layoutCell.answerPost = answerPost;
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.profilePicImageView.frame) + padding;
}

- (void)profileButtonPressed {
    if ([self.delegate respondsToSelector:@selector(didTapProfilePicOnAnswer:)]) {
        [self.delegate didTapProfilePicOnAnswer:self.answerPost];
    }
}

- (void)likeButtonPressed:(UIButton *)sender {
    [[DataSource sharedInstance] toggleLikeForAnswer:self.answerPost withSuccess:^(BOOL succeeded) {
        [[DataSource sharedInstance] likesForAnswer:self.answerPost withSuccess:^(NSArray *likes) {
            if (likes) {
                if ([self.delegate respondsToSelector:@selector(didToggleLikeOnAnswer:)]) {
                    [self.delegate didToggleLikeOnAnswer:self.answerPost];
                }
                if (likes.count == 1) {
                    self.likeButton.titleLabel.text = [NSString stringWithFormat:@"%lu like", (unsigned long)likes.count];
                } else {
                    self.likeButton.titleLabel.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)likes.count];
                }
            } else {
                NSLog(@"no likes");
            }
        }];
    }];
    [self layoutSubviews];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
