//
//  ProfileViewController.m
//  BloQuery
//
//  Created by Andrew Carvajal on 7/11/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "ProfileViewController.h"
#import "Parse/Parse.h"
#import "DataSource.h"

@interface ProfileViewController ()

@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIButton *profilePicEditButton;
@property (nonatomic, strong) UIView *descriptionView;
@property (nonatomic, strong) UIView *changeDescriptionView;
@property (nonatomic, strong) UITextView *descriptionTextView;
@property (nonatomic, strong) UILabel *descriptionTitleLabel;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ProfileViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        PFFile *imageFile = [PFUser currentUser][@"image"];
        [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
            if (!error) {
                UIImage *image = [UIImage imageWithData:data];
                self.profilePicImageView.image = image;
                self.descriptionLabel.text = [PFUser currentUser][@"description"];
            }
        }];

        self.profilePicEditButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.profilePicEditButton addTarget:self action:@selector(imagePressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithQuestionPost:(PFObject *)questionPost {
    self = [super init];
    if (self) {
        PFRelation *askedByRelation = [questionPost relationForKey:@"askedBy"];
        [[askedByRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                PFFile *imageFile = [objects lastObject][@"image"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        self.profilePicImageView.image = image;
                    }
                }];

                self.usernameLabel.text = [objects lastObject][@"username"];
                CGSize maxSizeForUsernameLabel = CGSizeMake(CGFLOAT_MAX, 42);
                CGSize sizeForUsernameLabel = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
                self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.usernameLabel.frame) / 2),
                                                      CGRectGetMaxY(self.profilePicImageView.frame) + 20,
                                                      sizeForUsernameLabel.width,
                                                      sizeForUsernameLabel.height);

                self.descriptionLabel.text = [objects lastObject][@"description"];

                self.profilePicEditButton = nil;
            }
        }];
    }
    return self;
}

- (instancetype)initWithAnswerPost:(PFObject *)answerPost {
    self = [super init];
    if (self) {
        PFRelation *askedByRelation = [answerPost relationForKey:@"repliedBy"];
        [[askedByRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                PFFile *imageFile = [objects lastObject][@"image"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        UIImage *image = [UIImage imageWithData:data];
                        self.profilePicImageView.image = image;
                    }
                }];

                self.usernameLabel.text = [objects lastObject][@"username"];
                CGSize maxSizeForUsernameLabel = CGSizeMake(CGFLOAT_MAX, 42);
                CGSize sizeForUsernameLabel = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
                self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.usernameLabel.frame) / 2),
                                                      CGRectGetMaxY(self.profilePicImageView.frame) + 20,
                                                      sizeForUsernameLabel.width,
                                                      sizeForUsernameLabel.height);

                self.descriptionLabel.text = [objects lastObject][@"description"];

                self.profilePicEditButton = nil;
            }
        }];
    }
    return self;
}

- (void)takePhotoOrChooseFromLibrary {
    [self.takeController takePhotoOrChooseFromLibrary];
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = [UIColor blackColor];

    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired)];

    self.profilePicImageView = [[UIImageView alloc] init];
    
    self.takeController = [[FDTakeController alloc] init];
    self.takeController.delegate = self;
    // You can optionally override action sheet titles
    self.takeController.takePhotoText = @"Take Photo";
    //	self.takeController.takeVideoText = @"Take Video";
    self.takeController.chooseFromPhotoRollText = @"Choose Existing";
    self.takeController.chooseFromLibraryText = @"Choose Existing";
    self.takeController.cancelText = @"Cancel";
    //	self.takeController.noSourcesText = @"No Photos Available";
    
    self.usernameLabel = [[UILabel alloc] init];
    self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:25];
    self.usernameLabel.textColor = [UIColor whiteColor];
    self.usernameLabel.text = [PFUser currentUser].username;

    self.descriptionView = [[UIView alloc] init];
    
    self.descriptionLabel = [[UILabel alloc] init];
    self.descriptionLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.textAlignment = NSTextAlignmentCenter;
    self.descriptionLabel.numberOfLines = 0;
    self.descriptionLabel.backgroundColor = [UIColor clearColor];
    
    self.changeDescriptionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.changeDescriptionButton addTarget:self action:@selector(changeDescriptionPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.changeDescriptionButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    [self.changeDescriptionButton setTitle:@"edit description" forState:UIControlStateNormal];
    self.changeDescriptionButton.titleLabel.textColor = [UIColor whiteColor];
    
    [self.view addSubview:self.profilePicImageView];
    [self.view addSubview:self.profilePicEditButton];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.descriptionView];
    [self.view addSubview:self.descriptionLabel];
    [self.view addSubview:self.changeDescriptionButton];
    [self.view addGestureRecognizer:self.tap];
    
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7,
                                 CGRectGetHeight(self.view.frame) * 0.4);

    self.profilePicImageView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.profilePicImageView.frame) / 2),
                                                100,
                                                130,
                                                130);
    self.profilePicEditButton.frame = CGRectMake(CGRectGetMinX(self.profilePicImageView.frame),
                                                 CGRectGetMinY(self.profilePicImageView.frame),
                                                 CGRectGetWidth(self.profilePicImageView.frame),
                                                 CGRectGetHeight(self.profilePicImageView.frame));

    CGSize maxSizeForUsernameLabel = CGSizeMake(CGFLOAT_MAX, 42);
    CGSize sizeForUsernameLabel = [self.usernameLabel sizeThatFits:maxSizeForUsernameLabel];
    self.usernameLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.usernameLabel.frame) / 2),
                                          CGRectGetMaxY(self.profilePicImageView.frame) + 20,
                                          sizeForUsernameLabel.width,
                                          sizeForUsernameLabel.height);
    
    self.descriptionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.descriptionView.frame) / 2),
                                            CGRectGetMaxY(self.usernameLabel.frame) + 20,
                                            viewSize.width,
                                            viewSize.height);
    CGSize maxSizeForDescriptionLabel = CGSizeMake(CGRectGetWidth(self.descriptionView.frame),
                                                   self.descriptionLabel.text.length);
    CGSize sizeForDescriptionLabel = [self.descriptionView sizeThatFits:maxSizeForDescriptionLabel];
    self.descriptionLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.descriptionLabel.frame) / 2),
                                             CGRectGetMaxY(self.usernameLabel.frame) + 20,
                                             sizeForDescriptionLabel.width,
                                             sizeForDescriptionLabel.height);
    
    self.changeDescriptionButton.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.changeDescriptionButton.frame) / 2),
                                                    CGRectGetMaxY(self.descriptionLabel.frame),
                                                    200,
                                                    42);
}

- (void)editingSwitchToggled:(id)sender
{
    self.takeController.allowsEditingPhoto = [(UISwitch *)sender isOn];
    self.takeController.allowsEditingVideo = [(UISwitch *)sender isOn];
}

- (void)imagePressed:(UIButton *)sender {
    [self takePhotoOrChooseFromLibrary];
}

#pragma mark - FDTakeDelegate

- (void)takeController:(FDTakeController *)controller didCancelAfterAttempting:(BOOL)madeAttempt
{
//    UIAlertView *alertView;
    if (madeAttempt) {}
//        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled after selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    else {}
//        alertView = [[UIAlertView alloc] initWithTitle:@"Example app" message:@"The take was cancelled without selecting media" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//    [alertView show];
}

- (void)takeController:(FDTakeController *)controller gotPhoto:(UIImage *)photo withInfo:(NSDictionary *)info {
    [[DataSource sharedInstance] postProfilePic:photo forUser:[PFUser currentUser] withSuccess:^(BOOL succeeded) {
        if (succeeded) {
            [self.profilePicImageView setImage:photo];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Miscellaneous

- (void)changeDescriptionPressed:(UIButton *)sender {
    sender = self.changeDescriptionButton;
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7,
                                 CGRectGetHeight(self.view.frame) * 0.4);
    
    if (!self.changeDescriptionView || self.changeDescriptionView.frame.origin.y < 0) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            
            // align view to center and above screen
            self.changeDescriptionView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                                                CGRectGetMinY(self.view.frame) - 1000,
                                                                                viewSize.width,
                                                                                viewSize.height)];
            
            // bring down to screen's center y
            self.changeDescriptionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                        CGRectGetMinY(self.profilePicImageView.frame),
                                                        viewSize.width,
                                                        viewSize.height);
            self.changeDescriptionView.backgroundColor = [UIColor whiteColor];
            
            self.descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                          5,
                                                                          viewSize.width,
                                                                          37)];
            self.descriptionTitleLabel.text = @"Change your description";
            self.descriptionTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.descriptionTitleLabel.textAlignment = NSTextAlignmentCenter;
            
            CGSize maxSizeForDescriptionTextView = CGSizeMake(viewSize.width - 15,
                                                              viewSize.height - CGRectGetHeight(self.descriptionTitleLabel.frame) - 15);
            CGSize sizeForDescriptionTextView = [self.changeDescriptionView sizeThatFits:maxSizeForDescriptionTextView];
            
            self.descriptionTextView = [[UITextView alloc] initWithFrame:CGRectMake(5,
                                                                                CGRectGetMaxY(self.descriptionTitleLabel.frame) + 5,
                                                                                    sizeForDescriptionTextView.width,
                                                                                    sizeForDescriptionTextView.height)];
            self.descriptionTextView.backgroundColor = [UIColor clearColor];
            self.descriptionTextView.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.descriptionTextView.returnKeyType = UIReturnKeyDone;
            self.descriptionTextView.keyboardAppearance = UIKeyboardAppearanceDark;
            
            self.cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.changeDescriptionView.frame),
                                                 CGRectGetMaxY(self.changeDescriptionView.frame),
                                                 viewSize.width / 2,
                                                 0);
            [self.cancelButton addTarget:self action:@selector(cancelFired:) forControlEvents:UIControlEventTouchUpInside];
            self.cancelButton.backgroundColor = [UIColor darkGrayColor];
            self.cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.cancelButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            self.submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.changeDescriptionView.frame), viewSize.width / 2, 0);
            [self.submitButton addTarget:self action:@selector(submitFired:) forControlEvents:UIControlEventTouchUpInside];
            self.submitButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:27/255.0 alpha:1];
            self.submitButton.titleLabel.textColor = [UIColor whiteColor];
            self.submitButton.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.submitButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            
            [self.view addSubview:self.changeDescriptionView];
            [self.changeDescriptionView addSubview:self.descriptionTitleLabel];
            [self.changeDescriptionView addSubview:self.descriptionTextView];
            [self.view addSubview:self.cancelButton];
            [self.view addSubview:self.submitButton];
        } completion:^(BOOL finished) {
            
            [self.descriptionTextView becomeFirstResponder];
            
            [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.changeDescriptionView.frame),
                                                     CGRectGetMaxY(self.changeDescriptionView.frame),
                                                     viewSize.width / 2,
                                                     37);
                self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                     CGRectGetMaxY(self.changeDescriptionView.frame),
                                                     viewSize.width / 2,
                                                     37);
                
            } completion:^(BOOL finished) {
                [self.cancelButton setTitle:@"cancel" forState:UIControlStateNormal];
                [self.submitButton setTitle:@"submit" forState:UIControlStateNormal];
            }];
        }];
    }
}

- (void)submitFired:(UIButton *)sender {
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    [self.descriptionTextView resignFirstResponder];
    
    // animate button press
    [UIView animateWithDuration:.1 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             (viewSize.width / 2),
                                             80);
    }];
    [UIView animateWithDuration:.42 animations:^{
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             viewSize.width / 2,
                                             37);
    }];
    
    // submit to parse for current user
    [[DataSource sharedInstance] postDescription:self.descriptionTextView.text forUser:[PFUser currentUser] withSuccess:^(BOOL succeeded) {
        self.descriptionLabel.text = [PFUser currentUser][@"description"];
    }];
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.changeDescriptionView.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             viewSize.width / 2,
                                             0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             viewSize.width / 2,
                                             0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.changeDescriptionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                        CGRectGetMinY(self.view.frame) - 1000,
                                                        viewSize.width,
                                                        viewSize.height);
            self.descriptionTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                 CGRectGetMaxY(self.changeDescriptionView.frame),
                                                 viewSize.width / 2,
                                                 0);
            self.descriptionTextView.frame = CGRectMake(5,
                                                    CGRectGetMinY(self.changeDescriptionView.frame) + 5,
                                                    CGRectGetWidth(self.changeDescriptionView.frame) - 10,
                                                    CGRectGetHeight(self.changeDescriptionView.frame) - CGRectGetHeight(self.descriptionTitleLabel.frame) - 10);
        } completion:^(BOOL finished) {
            [self.descriptionTextView resignFirstResponder];
        }];
    }];
    
    //clear out text view, hide keyboard, and refresh table
    self.descriptionTextView.text = @"";
    [self.descriptionTextView resignFirstResponder];
}

- (void)cancelFired:(UIButton *)sender {
    [self.descriptionTextView resignFirstResponder];
    
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    // hide compose view
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.changeDescriptionView.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             viewSize.width / 2,
                                             0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                             CGRectGetMaxY(self.changeDescriptionView.frame),
                                             viewSize.width / 2,
                                             0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.changeDescriptionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2),
                                                          CGRectGetMinY(self.view.frame) - 1000,
                                                          viewSize.width,
                                                          viewSize.height);
            self.descriptionTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame),
                                                          CGRectGetMaxY(self.changeDescriptionView.frame),
                                                          viewSize.width / 2,
                                                          0);
            self.descriptionTextView.frame = CGRectMake(5,
                                                        CGRectGetMinY(self.changeDescriptionView.frame) + 5,
                                                        CGRectGetWidth(self.changeDescriptionView.frame) - 10,
                                                        CGRectGetHeight(self.changeDescriptionView.frame) - CGRectGetHeight(self.descriptionTitleLabel.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
}

- (void)tapFired {
    [self.changeDescriptionView resignFirstResponder];
    
    CGSize viewSize = CGSizeMake(CGRectGetWidth(self.view.frame) * 0.7, CGRectGetHeight(self.view.frame) * 0.4);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        self.cancelButton.frame = CGRectMake(CGRectGetMinX(self.changeDescriptionView.frame), CGRectGetMaxY(self.changeDescriptionView.frame), viewSize.width / 2, 0);
        self.submitButton.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.changeDescriptionView.frame), viewSize.width / 2, 0);
        [self.cancelButton setTitle:@"" forState:UIControlStateNormal];
        [self.submitButton setTitle:@"" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.changeDescriptionView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (viewSize.width / 2), CGRectGetMinY(self.navigationController.navigationBar.frame) - 1000, viewSize.width, viewSize.height);
            self.descriptionTitleLabel.frame = CGRectMake(CGRectGetMaxX(self.cancelButton.frame), CGRectGetMaxY(self.changeDescriptionView.frame), viewSize.width / 2, 0);
            self.descriptionTextView.frame = CGRectMake(5, CGRectGetMinY(self.view.frame) * -2, CGRectGetWidth(self.changeDescriptionView.frame) - 10, CGRectGetHeight(self.changeDescriptionView.frame) - CGRectGetHeight(self.descriptionTitleLabel.frame) - 10);
        } completion:^(BOOL finished) {
            return;
        }];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
