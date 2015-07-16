//
//  QuestionTableViewCell.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/13/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "AnswersTableViewController.h"
#import "DataSource.h"

#import <Parse/Parse.h>

@interface QuestionTableViewCell()

@property (nonatomic, strong) UIView *thoughtBubble1a;
@property (nonatomic, strong) UIView *thoughtBubble1b;
@property (nonatomic, strong) UIView *thoughtBubble1c;
@property (nonatomic, strong) UIView *thoughtBubble1d;

@property (nonatomic, strong) UIView *thoughtBubble2a;
@property (nonatomic, strong) UIView *thoughtBubble2b;
@property (nonatomic, strong) UIView *thoughtBubble2c;
@property (nonatomic, strong) UIView *thoughtBubble2d;

@property (nonatomic, strong) UIView *thoughtBubble3a;
@property (nonatomic, strong) UIView *thoughtBubble3b;
@property (nonatomic, strong) UIView *thoughtBubble3c;
@property (nonatomic, strong) UIView *thoughtBubble3d;

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
        self.thoughtBubble1.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:27/255.0 alpha:1];
        self.thoughtBubble2.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:27/255.0 alpha:1];
        self.thoughtBubble3.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:27/255.0 alpha:1];
        
        self.thoughtBubble1a = [[UIView alloc] init];
        self.thoughtBubble1b = [[UIView alloc] init];
        self.thoughtBubble1c = [[UIView alloc] init];
        self.thoughtBubble1d = [[UIView alloc] init];
        self.thoughtBubble2a = [[UIView alloc] init];
        self.thoughtBubble2b = [[UIView alloc] init];
        self.thoughtBubble2c = [[UIView alloc] init];
        self.thoughtBubble2d = [[UIView alloc] init];
        self.thoughtBubble3a = [[UIView alloc] init];
        self.thoughtBubble3b = [[UIView alloc] init];
        self.thoughtBubble3c = [[UIView alloc] init];
        self.thoughtBubble3d = [[UIView alloc] init];
        
        self.faceImageView = [[UIImageView alloc] init];
        self.faceImageView.image = [UIImage imageNamed:@"xFace.png"];
        
        self.numberOfAnswersLabel = [[UILabel alloc] init];
        self.numberOfAnswersLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.numberOfAnswersLabel.textAlignment = NSTextAlignmentCenter;
        self.numberOfAnswersLabel.textColor = [UIColor whiteColor];
        self.numberOfAnswersLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
        
        self.usernameLabel = [[UILabel alloc] init];
        self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.usernameLabel.textAlignment = NSTextAlignmentCenter;
        self.usernameLabel.textColor = [UIColor whiteColor];
        self.usernameLabel.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];

        [self.contentView addSubview:self.questionBox];
        [self.contentView addSubview:self.questionLabel];
        [self addThoughtBubbles];
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.numberOfAnswersLabel];
        [self.contentView addSubview:self.usernameLabel];
    }
    return self;
}

- (void)setQuestionPost:(PFObject *)questionPost {
    _questionPost = questionPost;
    self.questionLabel.text = questionPost[@"text"];
    [[DataSource sharedInstance] answersForQuestion:self.questionPost withSuccess:^(NSArray *answers) {
        if (answers.count < 1) {
            self.numberOfAnswersLabel.text = @"no answers yet";
        } else if (answers.count == 1) {
            self.numberOfAnswersLabel.text = @"1 answer";
        } else {
            self.numberOfAnswersLabel.text = [NSString stringWithFormat:@"%ld answers", (long)answers.count];
        }
    }];
    [[DataSource sharedInstance] usernameForQuestion:self.questionPost withSuccess:^(NSArray *user) {
        self.usernameLabel.text = [user lastObject][@"username"];
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
    [self setUpSecondaryThoughtBubbles];
    self.faceImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 63,
                                          CGRectGetMaxY(self.thoughtBubble3.frame) + padding,
                                          53,
                                          53);
    CGSize maxSizeForNumberOfAnswersLabel = CGSizeMake(CGRectGetWidth(self.questionBox.frame),
                                                       69);
    CGSize numberOfAnswersLabelSize = [self.numberOfAnswersLabel sizeThatFits:maxSizeForNumberOfAnswersLabel];
    self.numberOfAnswersLabel.frame = CGRectMake(CGRectGetMidX(self.questionBox.frame) - numberOfAnswersLabelSize.width / 2,
                                                 CGRectGetMaxY(self.questionBox.frame) + padding,
                                                 numberOfAnswersLabelSize.width + padding,
                                                 numberOfAnswersLabelSize.height + padding);
    
    CGSize maxSizeForUsernameLabel = CGSizeMake(CGRectGetWidth(self.questionBox.frame),
                                                69);
    CGSize usernameLabelSize = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
    self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.questionBox.frame) - usernameLabelSize.width / 2,
                                          CGRectGetMaxY(self.numberOfAnswersLabel.frame) + padding,
                                          usernameLabelSize.width + padding,
                                          usernameLabelSize.height + padding);
}

+ (CGFloat)heightForQuestionPost:(PFObject *)questionPost withWidth:(CGFloat)width {
    // Make a cell
    QuestionTableViewCell *layoutCell = [[QuestionTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"layoutCell"];
    layoutCell.questionPost = questionPost;
    layoutCell.frame = CGRectMake(0, 0, width, CGRectGetHeight(layoutCell.frame));
    
    [layoutCell setNeedsLayout];
    [layoutCell layoutIfNeeded];
    
    // Get the actual height required for the cell
    return CGRectGetMaxY(layoutCell.faceImageView.frame);
}

- (void)addThoughtBubbles {
    [self.contentView addSubview:self.thoughtBubble1];
    [self.contentView addSubview:self.thoughtBubble2];
    [self.contentView addSubview:self.thoughtBubble3];
    
    [self.contentView addSubview:self.thoughtBubble1a];
    [self.contentView addSubview:self.thoughtBubble1b];
    [self.contentView addSubview:self.thoughtBubble1c];
    [self.contentView addSubview:self.thoughtBubble1d];
    
    [self.contentView addSubview:self.thoughtBubble2a];
    [self.contentView addSubview:self.thoughtBubble2b];
    [self.contentView addSubview:self.thoughtBubble2c];
    [self.contentView addSubview:self.thoughtBubble2d];
    
    [self.contentView addSubview:self.thoughtBubble3a];
    [self.contentView addSubview:self.thoughtBubble3b];
    [self.contentView addSubview:self.thoughtBubble3c];
    [self.contentView addSubview:self.thoughtBubble3d];
}

- (void)setUpSecondaryThoughtBubbles {
    
    CGSize sizeForSecondaryThoughtBubble1 = CGSizeMake(CGRectGetWidth(self.thoughtBubble1.frame) * 0.7, CGRectGetHeight(self.thoughtBubble1.frame) * 0.7);
    CGSize sizeForSecondaryThoughtBubble2 = CGSizeMake(CGRectGetWidth(self.thoughtBubble2.frame) * 0.7, CGRectGetHeight(self.thoughtBubble2.frame) * 0.7);
    CGSize sizeForSecondaryThoughtBubble3 = CGSizeMake(CGRectGetWidth(self.thoughtBubble3.frame) * 0.7, CGRectGetHeight(self.thoughtBubble3.frame) * 0.7);
    
    self.thoughtBubble1a.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.width / 2, CGRectGetMinY(self.thoughtBubble1.frame) - 2, sizeForSecondaryThoughtBubble1.width, sizeForSecondaryThoughtBubble1.height);
    self.thoughtBubble1b.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.width + 2, CGRectGetMidY(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.height / 2, sizeForSecondaryThoughtBubble1.width, sizeForSecondaryThoughtBubble1.height);
    self.thoughtBubble1c.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.width / 2, CGRectGetMaxY(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.height + 2, sizeForSecondaryThoughtBubble1.width, sizeForSecondaryThoughtBubble1.height);
    self.thoughtBubble1d.frame = CGRectMake(CGRectGetMinX(self.thoughtBubble1.frame) - 2, CGRectGetMidY(self.thoughtBubble1.frame) - sizeForSecondaryThoughtBubble1.height / 2, sizeForSecondaryThoughtBubble1.width, sizeForSecondaryThoughtBubble1.height);
    
    self.thoughtBubble2a.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.width / 2, CGRectGetMinY(self.thoughtBubble2.frame) - 1, sizeForSecondaryThoughtBubble2.width, sizeForSecondaryThoughtBubble2.height);
    self.thoughtBubble2b.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.width + 1, CGRectGetMidY(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.height / 2, sizeForSecondaryThoughtBubble2.width, sizeForSecondaryThoughtBubble2.height);
    self.thoughtBubble2c.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.width / 2, CGRectGetMaxY(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.height + 1, sizeForSecondaryThoughtBubble2.width, sizeForSecondaryThoughtBubble2.height);
    self.thoughtBubble2d.frame = CGRectMake(CGRectGetMinX(self.thoughtBubble2.frame) - 1, CGRectGetMidY(self.thoughtBubble2.frame) - sizeForSecondaryThoughtBubble2.height / 2, sizeForSecondaryThoughtBubble2.width, sizeForSecondaryThoughtBubble2.height);
    
    self.thoughtBubble3a.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.width / 2, CGRectGetMinY(self.thoughtBubble3.frame) - 0.4, sizeForSecondaryThoughtBubble3.width, sizeForSecondaryThoughtBubble3.height);
    self.thoughtBubble3b.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.width + 0.4, CGRectGetMidY(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.height / 2, sizeForSecondaryThoughtBubble3.width, sizeForSecondaryThoughtBubble3.height);
    self.thoughtBubble3c.frame = CGRectMake(CGRectGetMidX(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.width / 2, CGRectGetMaxY(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.height + 0.4, sizeForSecondaryThoughtBubble3.width, sizeForSecondaryThoughtBubble3.height);
    self.thoughtBubble3d.frame = CGRectMake(CGRectGetMinX(self.thoughtBubble3.frame) - 0.4, CGRectGetMidY(self.thoughtBubble3.frame) - sizeForSecondaryThoughtBubble3.height / 2, sizeForSecondaryThoughtBubble3.width, sizeForSecondaryThoughtBubble3.height);
    
    self.thoughtBubble1a.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble1b.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble1c.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble1d.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    
    self.thoughtBubble2a.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble2b.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble2c.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble2d.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    
    self.thoughtBubble3a.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble3b.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble3c.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
    self.thoughtBubble3d.backgroundColor = [UIColor colorWithRed:226/255.0 green:39/255.0 blue:68/255.0 alpha:1];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
    // Configure the view for the selected state
}

@end
