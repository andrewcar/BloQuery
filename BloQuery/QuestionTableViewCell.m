//
//  QuestionTableViewCell.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/13/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "QuestionTableViewCell.h"
#import "DataSource.h"

@interface QuestionTableViewCell()

@property (nonatomic, strong) UIView *thoughtBubble1;
@property (nonatomic, strong) UIView *thoughtBubble2;
@property (nonatomic, strong) UIView *thoughtBubble3;

@end

@implementation QuestionTableViewCell

CGFloat padding = 20;

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.1 green:0.55 blue:0.69 alpha:1];
        
        self.questionBox = [[UIView alloc] init];
        self.questionBox.backgroundColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
        
        self.questionLabel = [[UILabel alloc] init];
        self.questionLabel.backgroundColor = [UIColor clearColor];        
        self.questionLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17];
        self.questionLabel.textColor = [UIColor whiteColor];
        self.questionLabel.textAlignment = NSTextAlignmentLeft;
        self.questionLabel.numberOfLines = 0;
        
        self.thoughtBubble1 = [[UIView alloc] init];
        self.thoughtBubble2 = [[UIView alloc] init];
        self.thoughtBubble3 = [[UIView alloc] init];
        self.thoughtBubble1.backgroundColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
        self.thoughtBubble2.backgroundColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
        self.thoughtBubble3.backgroundColor = [UIColor colorWithRed:0.889 green:0.199 blue:0.333 alpha:1];
        
        self.faceImageView = [[UIImageView alloc] init];
        self.faceImageView.image = [UIImage imageNamed:@"xFace.png"];
        
        self.numberOfAnswersLabel = [[UILabel alloc] init];
        self.numberOfAnswersLabel.text = @"12 answers";
        self.numberOfAnswersLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
        self.numberOfAnswersLabel.textAlignment = NSTextAlignmentCenter;
        self.numberOfAnswersLabel.textColor = [UIColor whiteColor];
        
        [self.contentView addSubview:self.questionBox];
        [self.contentView addSubview:self.questionLabel];
        [self.contentView addSubview:self.thoughtBubble1];
        [self.contentView addSubview:self.thoughtBubble2];
        [self.contentView addSubview:self.thoughtBubble3];
        [self.contentView addSubview:self.faceImageView];
        [self.contentView addSubview:self.numberOfAnswersLabel];
    }
    return self;
}

- (void)layoutSubviews {
    CGSize maxSizeForQuestionLabel = CGSizeMake(CGRectGetWidth(self.contentView.frame) - (padding * 2), CGFLOAT_MAX);
    CGSize questionLabelSize = [self.questionLabel sizeThatFits:maxSizeForQuestionLabel];
    self.questionBox.frame = CGRectMake(padding, padding, (CGRectGetWidth(self.contentView.frame) * 0.75) + (padding * 2), questionLabelSize.height + (padding * 2));
    self.questionLabel.frame = CGRectMake(CGRectGetMinX(self.questionBox.frame) + padding, CGRectGetMinY(self.questionBox.frame) + padding, CGRectGetWidth(self.questionBox.frame) - (padding * 2), CGRectGetHeight(self.questionBox.frame) - (padding * 2));
    
    self.thoughtBubble1.frame = CGRectMake(CGRectGetMaxX(self.questionBox.frame) + 11, CGRectGetMinY(self.questionBox.frame) + 11, 15, 15);
    self.thoughtBubble2.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble1.frame) + 2, CGRectGetMinY(self.thoughtBubble1.frame) + 25, 10, 10);
    self.thoughtBubble3.frame = CGRectMake(CGRectGetMaxX(self.thoughtBubble2.frame) - 4, CGRectGetMinY(self.thoughtBubble2.frame) + 26, 5, 5);
    
    self.faceImageView.frame = CGRectMake(CGRectGetWidth(self.contentView.frame) - 63, CGRectGetMaxY(self.thoughtBubble3.frame) + padding, 53, 53);
    
    CGSize maxSizeForNumberOfAnswersLabel = CGSizeMake(CGRectGetWidth(self.questionBox.frame), 35);
    CGSize numberOfAnswersLabelSize = [self.numberOfAnswersLabel sizeThatFits:maxSizeForNumberOfAnswersLabel];
    self.numberOfAnswersLabel.frame = CGRectMake(CGRectGetMinX(self.contentView.frame) + padding, CGRectGetMaxY(self.questionBox.frame) + 8, numberOfAnswersLabelSize.width + padding, 25);
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

- (void)setQuestionPost:(PFObject *)questionPost {
    _questionPost = questionPost;
    self.questionLabel.text = questionPost[@"text"];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:NO];
    // Configure the view for the selected state
}

@end
