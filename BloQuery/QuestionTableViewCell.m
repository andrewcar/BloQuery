//
//  QuestionTableViewCell.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/13/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "AnswersTableViewController.h"
#import "ProfileViewController.h"
#import "DataSource.h"

#import <Parse/Parse.h>

@interface QuestionTableViewCell()

@end

@implementation QuestionTableViewCell

#define padding 20

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.questionBox = [[UIView alloc] init];
        self.questionBox.backgroundColor = [UIColor colorWithRed:25/255.0 green:134/255.0 blue:235/255.0 alpha:1];
        
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.backgroundColor = [UIColor clearColor];        
        self.questionLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.questionLabel.textColor = [UIColor whiteColor];
        self.questionLabel.textAlignment = NSTextAlignmentLeft;
        self.questionLabel.numberOfLines = 0;
        
        self.thoughtBubble1 = [[UIView alloc] init];
        self.thoughtBubble2 = [[UIView alloc] init];
        self.thoughtBubble3 = [[UIView alloc] init];
        self.thoughtBubble1.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        self.thoughtBubble2.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        self.thoughtBubble3.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        
        self.profilePicImageView = [[UIImageView alloc] init];
        self.profileButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.profileButton addTarget:self action:@selector(profileButtonPressed) forControlEvents:UIControlEventTouchUpInside];

        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];

        self.numberOfAnswersLabel = [[UILabel alloc] init];
        self.numberOfAnswersLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.numberOfAnswersLabel.textAlignment = NSTextAlignmentCenter;
        self.numberOfAnswersLabel.textColor = [UIColor whiteColor];
        self.numberOfAnswersLabel.backgroundColor = [UIColor colorWithRed:25/255.0 green:134/255.0 blue:235/255.0 alpha:1];

        [self.contentView addSubview:self.questionBox];
        [self.contentView addSubview:self.questionLabel];
        [self addThoughtBubbles];
        [self.contentView addSubview:self.profilePicImageView];
        [self.contentView addSubview:self.profileButton];
        [self.contentView addSubview:self.usernameLabel];
        [self.contentView addSubview:self.numberOfAnswersLabel];
    }
    return self;
}

- (void)setQuestionPost:(PFObject *)questionPost {
    _questionPost = questionPost;
    self.questionLabel.text = questionPost[@"text"];
    [[DataSource sharedInstance] usernameForQuestion:self.questionPost withSuccess:^(NSArray *user) {
        self.usernameLabel.text = [NSString stringWithFormat:@"by %@", [user lastObject][@"username"]];
        PFFile *imageFile = [user lastObject][@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            self.profilePicImageView.image = [UIImage imageWithData:data];
        }];
    }];
    [[DataSource sharedInstance] answersForQuestion:self.questionPost withSuccess:^(NSArray *answers) {
        if (answers.count < 1) {
            self.numberOfAnswersLabel.text = @"0 answers";
        } else if (answers.count == 1) {
            self.numberOfAnswersLabel.text = @"1 answer";
        } else {
            self.numberOfAnswersLabel.text = [NSString stringWithFormat:@"%ld answers", (long)answers.count];
        }
    }];
}

- (void)layoutSubviews {
    CGSize maxSizeForQuestionLabel = CGSizeMake(CGRectGetWidth(self.contentView.frame) * 0.72,
                                                CGFLOAT_MAX);
    CGSize questionLabelSize = [self.questionLabel sizeThatFits:maxSizeForQuestionLabel];
    self.questionLabel.frame = CGRectMake(padding * 2,
                                          padding * 2,
                                          questionLabelSize.width,
                                          questionLabelSize.height);
    self.questionBox.frame = CGRectMake(padding,
                                        padding,
                                        (CGRectGetWidth(self.contentView.frame) * 0.72) + (padding * 2),
                                        questionLabelSize.height + (padding * 2));
    self.thoughtBubble1.frame = CGRectMake(CGRectGetMaxX(self.questionBox.frame) + 11,
                                           CGRectGetMinY(self.questionBox.frame) + 11,
                                           15,
                                           15);
    self.thoughtBubble2.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble1.frame) + 1,
                                           CGRectGetMinY(self.thoughtBubble1.frame) + 25,
                                           10,
                                           10);
    self.thoughtBubble3.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble2.frame) - 4,
                                           CGRectGetMinY(self.thoughtBubble2.frame) + 26,
                                           5,
                                           5);
    self.profilePicImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 63,
                                          CGRectGetMaxY(self.thoughtBubble3.frame) + padding,
                                          53,
                                          53);
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.height / 3;
    self.profilePicImageView.layer.masksToBounds = YES;
    self.profilePicImageView.layer.borderWidth = 0;

    self.profileButton.frame = CGRectMake(CGRectGetMinX(self.profilePicImageView.frame), CGRectGetMinY(self.profilePicImageView.frame), CGRectGetWidth(self.profilePicImageView.frame), CGRectGetHeight(self.profilePicImageView.frame));
    
    CGSize maxSizeForUsernameLabel = CGSizeMake(CGRectGetWidth(self.questionBox.frame),
                                                69);
    CGSize usernameLabelSize = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
    self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.questionBox.frame) - usernameLabelSize.width / 2,
                                          CGRectGetMaxY(self.questionBox.frame) + padding,
                                          usernameLabelSize.width + padding,
                                          usernameLabelSize.height + padding);
    CGSize maxSizeForNumberOfAnswersLabel = CGSizeMake(CGRectGetWidth(self.questionBox.frame),
                                                       69);
    CGSize numberOfAnswersLabelSize = [self.numberOfAnswersLabel sizeThatFits:maxSizeForNumberOfAnswersLabel];
    self.numberOfAnswersLabel.frame = CGRectMake(CGRectGetMidX(self.questionBox.frame) - numberOfAnswersLabelSize.width / 2,
                                                 CGRectGetMaxY(self.usernameLabel.frame) + padding,
                                                 numberOfAnswersLabelSize.width + padding,
                                                 numberOfAnswersLabelSize.height + padding);
}

+ (CGFloat)heightForQuestionPost:(PFObject *)questionPost withWidth:(CGFloat)width {
    // Make a cell
    QuestionTableViewCell *layoutCell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    layoutCell.questionPost = questionPost;
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.profilePicImageView.frame) + 50;
}

- (void)profileButtonPressed {
    if ([self.delegate respondsToSelector:@selector(didTapProfilePicOnQuestion:)]) {
        [self.delegate didTapProfilePicOnQuestion:self.questionPost];
    }
}

- (void)addThoughtBubbles {
    [self.contentView addSubview:self.thoughtBubble1];
    [self.contentView addSubview:self.thoughtBubble2];
    [self.contentView addSubview:self.thoughtBubble3];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
    // Configure the view for the selected state
}

@end
