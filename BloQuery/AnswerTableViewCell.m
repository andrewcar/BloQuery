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
        
        self.faceImageView = [[UIImageView alloc] init];
        
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        
        [self.contentView addSubview:self.answerBox];
        [self.contentView addSubview:self.answerLabel];
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.usernameLabel];
    }
    return self;
}

- (void)setAnswerPost:(PFObject *)answerPost {
    _answerPost = answerPost;
    self.answerLabel.text = answerPost[@"text"];
    [[DataSource sharedInstance] usernameForAnswer:_answerPost withSuccess:^(NSArray *user) {
        self.usernameLabel.text = [user lastObject][@"username"];
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
    self.faceImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 63,
                                          CGRectGetMaxY(self.answerBox.frame) - 33,
                                          53,
                                          53);
    CGSize maxSizeForUsernameLabel = CGSizeMake(CGRectGetWidth(self.answerBox.frame),
                                                       69);
    CGSize usernameLabelSize = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
    self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.answerBox.frame) - usernameLabelSize.width / 2,
                                                 CGRectGetMaxY(self.answerBox.frame) + padding,
                                                 usernameLabelSize.width + padding,
                                                 usernameLabelSize.height + padding);
}

+ (CGFloat)heightForAnswerPost:(PFObject *)answerPost withWidth:(CGFloat)width {
    // Make a cell
    AnswerTableViewCell *layoutCell = [[AnswerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    layoutCell.answerPost = answerPost;
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.usernameLabel.frame);
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
