//
//  ProfileViewController.h
//  BloQuery
//
//  Created by Andrew Carvajal on 7/11/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"
#import "Parse/Parse.h"

@interface ProfileViewController : UIViewController <FDTakeDelegate>

@property FDTakeController *takeController;
@property (nonatomic, strong) UIImageView *profilePicImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *descriptionLabel;
@property (nonatomic, strong) UIButton *changeDescriptionButton;

- (instancetype)initWithQuestionPost:(PFObject *)questionPost;
- (instancetype)initWithAnswerPost:(PFObject *)answerPost;
- (void)takePhotoOrChooseFromLibrary;
- (void)editingSwitchToggled:(id)sender;

@end
