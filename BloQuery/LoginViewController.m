//
//  LoginViewController.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/1/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "LoginViewController.h"
#import "QuestionsTableViewController.h"
#import "Parse/Parse.h"

@interface LoginViewController () <UITextFieldDelegate>

@property (nonatomic, strong) UILabel *logoLabel;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *passwordLabel;
@property (nonatomic, strong) UITextField *usernameField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIButton *signUpButton;
@property (nonatomic, strong) UIButton *logInButton;
@property (nonatomic, strong) UITextField *verifyPasswordField;
@property (nonatomic, strong) UILabel *verifyPasswordLabel;
@property (nonatomic, strong) UILabel *nowLogInLabel;
@property (nonatomic, strong) UIView *requirementsView;
@property (nonatomic, strong) UILabel *requirementsTitleLabel;
@property (nonatomic, strong) UILabel *requirementsLabel1;
@property (nonatomic, strong) UILabel *requirementsLabel2;
@property (nonatomic, strong) UILabel *requirementsLabel3;
@property (nonatomic, strong) UILabel *requirementsLabel4;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = [UIColor colorWithRed:25/255.0 green:134/255.0 blue:235/255.0 alpha:1];
    
    // tapFired method
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapFired:)];
    tap.cancelsTouchesInView = NO;
    
    // values
    CGFloat textFieldWidth = CGRectGetWidth(self.view.frame) * 0.75;
    CGFloat buttonWidth = CGRectGetWidth(self.view.frame) * 0.33;
    CGFloat padding = CGRectGetMidX(self.view.frame) - (textFieldWidth / 2);
    
    self.logoLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding, textFieldWidth, textFieldWidth * 0.5)];
    self.logoLabel.textColor = [UIColor whiteColor];
    self.logoLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:69];
    self.logoLabel.textAlignment = NSTextAlignmentCenter;
    self.logoLabel.text = @"BloQuery";
    
    self.usernameField = [[UITextField alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame) - textFieldWidth) / 2, (CGRectGetHeight(self.view.frame) / 2) * 1.17, textFieldWidth, 42)];
    self.usernameField.delegate = self;
    self.usernameField.backgroundColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    self.usernameField.textColor = [UIColor whiteColor];
    self.usernameField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.usernameField.textAlignment = NSTextAlignmentCenter;
    self.usernameField.autocorrectionType = UITextAutocorrectionTypeNo;
    self.usernameField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.usernameField.returnKeyType = UIReturnKeyNext;
    self.usernameField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.usernameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 40, textFieldWidth, 42)];
    self.usernameLabel.textColor = [UIColor whiteColor];
    self.usernameLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.usernameLabel.text = @"username";
    
    self.passwordField = [[UITextField alloc] init];
    self.passwordField.delegate = self;
    self.passwordField.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame), (CGRectGetMaxY(self.usernameField.frame) + 69), textFieldWidth, 42);
    self.passwordField.backgroundColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    self.passwordField.textColor = [UIColor whiteColor];
    self.passwordField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.passwordField.textAlignment = NSTextAlignmentCenter;
    self.passwordField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.passwordField.clearsOnBeginEditing = YES;
    self.passwordField.returnKeyType = UIReturnKeyDone;
    self.passwordField.secureTextEntry = YES;
    self.passwordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.passwordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.passwordField.frame) - 40, CGRectGetWidth(self.passwordField.frame), CGRectGetHeight(self.passwordField.frame))];
    self.passwordLabel.textColor = [UIColor whiteColor];
    self.passwordLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.passwordLabel.text = @"password";
    
    self.verifyPasswordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 69, CGRectGetWidth(self.view.frame) * 0.75, 0)];
    self.verifyPasswordField.delegate = self;
    self.verifyPasswordField.backgroundColor = [UIColor colorWithRed:42/255.0 green:42/255.0 blue:42/255.0 alpha:1];
    self.verifyPasswordField.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.verifyPasswordField.textColor = [UIColor whiteColor];
    self.verifyPasswordField.textAlignment = NSTextAlignmentCenter;
    self.verifyPasswordField.secureTextEntry = YES;
    self.verifyPasswordField.keyboardAppearance = UIKeyboardAppearanceDark;
    self.verifyPasswordField.returnKeyType = UIReturnKeyDone;
    self.verifyPasswordField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    
    self.signUpButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.signUpButton.frame = CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame) + 62, buttonWidth, 42);
    [self.signUpButton addTarget:self action:@selector(signUpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.signUpButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
    
    [self.signUpButton setTitle:@"sign up" forState:UIControlStateNormal];
    self.signUpButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.signUpButton.titleLabel.textColor = [UIColor whiteColor];
    self.signUpButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.signUpButton setTag:2222];
    
    self.logInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.logInButton.frame = CGRectMake(CGRectGetMaxX(self.passwordField.frame) - buttonWidth, CGRectGetMaxY(self.passwordField.frame) + 62, buttonWidth, 42);
    [self.logInButton addTarget:self action:@selector(logInButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.logInButton.backgroundColor = [UIColor colorWithRed:200/255.0 green:24/255.0 blue:46/255.0 alpha:1];
    [self.logInButton setTitle:@"log in" forState:UIControlStateNormal];
    self.logInButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
    self.logInButton.titleLabel.textColor = [UIColor whiteColor];
    self.logInButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.view addGestureRecognizer:tap];
    [self.view addSubview:self.logoLabel];
    [self.view addSubview:self.usernameLabel];
    [self.view addSubview:self.passwordLabel];
    [self.view addSubview:self.usernameField];
    [self.view addSubview:self.passwordField];
    [self.view addSubview:self.verifyPasswordField];
    [self.view addSubview:self.signUpButton];
    [self.view addSubview:self.logInButton];
}

#pragma mark - Text Fields

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    // values
    CGFloat viewHeightForUsernameField = -30;
    CGFloat viewHeightForPasswordField = -144;
    
    // raise view when text fields tapped
    if (textField == _usernameField) {
        [UIView animateWithDuration:0.2 animations:^{
            self.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), viewHeightForUsernameField, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            self.logoLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2) - viewHeightForUsernameField, CGRectGetWidth(self.view.frame) * 0.75, (CGRectGetWidth(self.view.frame) * 0.75) * 0.5);
        }];
    } else if (textField == _passwordField) {
        [UIView animateWithDuration:0.3 animations:^{
            self.view.frame = CGRectMake(CGRectGetMinX(self.view.frame), viewHeightForPasswordField, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            self.logoLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2) - viewHeightForPasswordField, CGRectGetWidth(self.view.frame) * 0.75, (CGRectGetWidth(self.view.frame) * 0.75) * 0.5);
        }];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    // if return is tapped on username text field, move to password
    if (textField == _usernameField) {
        [_passwordField becomeFirstResponder];
     
    // if return is tapped on password field, hide keyboard, move view down
    } else if (textField == _passwordField) {
        [textField resignFirstResponder];
        [UIView animateWithDuration:0.4 animations:^{
            self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
            self.logoLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetWidth(self.view.frame) * 0.75, (CGRectGetWidth(self.view.frame) * 0.75) * 0.5);
        }];
        
    // if return is tapped on verify text field, hide keyboard
    } else if (textField == _verifyPasswordField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)setUpPasswordVerification {
    
    // if height of verify text field is 0, clear the text and raise height to 42, making it visible
    if (self.verifyPasswordField.frame.size.height == 0) {
        [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.verifyPasswordField.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 111, CGRectGetWidth(self.view.frame) * 0.75, 42);
            self.verifyPasswordField.text = @"";
            
            // when that completes, create, configure and add a verify label above the text field
        } completion:^(BOOL finished) {
            self.verifyPasswordLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.verifyPasswordField.frame), CGRectGetMinY(self.verifyPasswordField.frame) - 40, CGRectGetWidth(self.verifyPasswordField.frame), CGRectGetHeight(self.verifyPasswordField.frame))];
            self.verifyPasswordLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.verifyPasswordLabel.textColor = [UIColor whiteColor];
            self.verifyPasswordLabel.text = @"verify password";
            
            [self.view addSubview:self.verifyPasswordLabel];
        }];
        
        // else if the height was not 0 (then it was 42), make a verify label disappear before a verify text field
    } else {
        [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.verifyPasswordField.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 69, CGRectGetWidth(self.view.frame) * 0.75, 0);
            self.verifyPasswordLabel.frame = CGRectMake(CGRectGetMinX(self.verifyPasswordField.frame), CGRectGetMinY(self.verifyPasswordField.frame) - 40, CGRectGetWidth(self.verifyPasswordField.frame), 0);
            self.verifyPasswordLabel.text = @"";
        } completion:^(BOOL finished) {
            return;
        }];
    }
}

#pragma mark - Buttons

// 1111 is for success state
// 2222 is for sign up state

- (void)signUpButtonPressed:(UIButton *)sender {
    if (sender.tag == 1111) {
        [UIView animateWithDuration:0.4 animations:^{
            self.nowLogInLabel.alpha = 0;
            
            sender.tag = 2222;
            [self.signUpButton setTitle:@"sign up" forState:UIControlStateNormal];
        }];
    } else if (sender.tag == 2222) {
        [self animateSignUpButtonPress];
        
        if (self.passwordField.text.length != 0) {
            [self setUpPasswordVerification];
            
            if ([self.verifyPasswordField.text isEqualToString:self.passwordField.text]) {
                if ([self passwordMeetsRequirements:self.passwordField.text]) {
                    [self signUp];
                } else {
                    
                    // if it doesn't meet requirements, hide verify text field
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                        self.verifyPasswordField.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 69, CGRectGetWidth(self.view.frame) * 0.75, 0);
                        self.verifyPasswordLabel.frame = CGRectMake(CGRectGetMinX(self.verifyPasswordField.frame), CGRectGetMinY(self.verifyPasswordField.frame) - 40, CGRectGetWidth(self.verifyPasswordField.frame), 0);
                    } completion:^(BOOL finished) {
                        self.passwordField.text = @"";
                    }];
                    
                    // show requirements
                    [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
                        self.requirementsView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.usernameField.frame) - 10, CGRectGetMaxY(self.view.frame), CGRectGetWidth(self.usernameField.frame) + 30, (CGRectGetHeight(self.view.frame) - 400))];
                        self.requirementsView.frame = CGRectMake(CGRectGetMidX(self.view.frame) - (CGRectGetWidth(self.requirementsView.frame) / 2), (CGRectGetMinY(self.view.frame) + 150), CGRectGetWidth(self.usernameField.frame) + 30, (CGRectGetHeight(self.view.frame) - 400));
                        self.requirementsView.backgroundColor = [UIColor colorWithRed:220/255.0 green:26/255.0 blue:30/255.0 alpha:1];
                        
                        [self.view addSubview:self.requirementsView];
                    } completion:^(BOOL finished) {
                        self.requirementsTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.requirementsView.frame) + 20, CGRectGetMinY(self.requirementsView.frame) + 25, CGRectGetWidth(self.requirementsView.frame) - 40, 42)];
                        self.requirementsTitleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:35];
                        self.requirementsTitleLabel.text = @"Requirements";
                        self.requirementsTitleLabel.textAlignment = NSTextAlignmentCenter;
                        self.requirementsTitleLabel.textColor = [UIColor blackColor];
                        
                        self.requirementsLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.requirementsView.frame) + 25, CGRectGetMaxY(self.requirementsTitleLabel.frame) + 40, CGRectGetWidth(self.requirementsTitleLabel.frame), CGRectGetHeight(self.requirementsTitleLabel.frame))];
                        self.requirementsLabel1.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
                        self.requirementsLabel1.text = @"Between 6 and 20 characters in length";
                        self.requirementsLabel1.textAlignment = NSTextAlignmentLeft;
                        self.requirementsLabel1.textColor = [UIColor whiteColor];
                        
                        self.requirementsLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.requirementsView.frame) + 25, CGRectGetMaxY(self.requirementsLabel1.frame), CGRectGetWidth(self.requirementsTitleLabel.frame), CGRectGetHeight(self.requirementsTitleLabel.frame))];
                        self.requirementsLabel2.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
                        self.requirementsLabel2.text = @"1 letter 1, 1 number, 1 special char";
                        self.requirementsLabel2.textAlignment = NSTextAlignmentLeft;
                        self.requirementsLabel2.textColor = [UIColor whiteColor];
                        
                        self.requirementsLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.requirementsView.frame) + 25, CGRectGetMaxY(self.requirementsLabel2.frame), CGRectGetWidth(self.requirementsTitleLabel.frame), CGRectGetHeight(self.requirementsTitleLabel.frame))];
                        self.requirementsLabel3.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:16];
                        self.requirementsLabel3.text = @"Only use these :";
                        self.requirementsLabel3.textAlignment = NSTextAlignmentLeft;
                        self.requirementsLabel3.textColor = [UIColor whiteColor];
                        
                        self.requirementsLabel4 = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.requirementsView.frame) + 25, CGRectGetMaxY(self.requirementsLabel3.frame), CGRectGetWidth(self.requirementsTitleLabel.frame), CGRectGetHeight(self.requirementsTitleLabel.frame))];
                        self.requirementsLabel4.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:17];
                        self.requirementsLabel4.text = @"~`!@#$%^&*()_-+=,.?;:'<>";
                        self.requirementsLabel4.textAlignment = NSTextAlignmentLeft;
                        self.requirementsLabel4.textColor = [UIColor whiteColor];
                        
                        [self.view addSubview:self.requirementsTitleLabel];
                        [self.view addSubview:self.requirementsLabel1];
                        [self.view addSubview:self.requirementsLabel2];
                        [self.view addSubview:self.requirementsLabel3];
                        [self.view addSubview:self.requirementsLabel4];
                    }];
                }
            }
        }
    }
}

- (void)logInButtonPressed:(UIButton *)sender {
    sender.tag = 3333;
    [self animateLogInButtonPress];
    [self logIn];
}

- (void)animateSignUpButtonPress {
    [UIView animateWithDuration:.1 animations:^{
        self.signUpButton.frame = CGRectMake(CGRectGetMinX(self.passwordField.frame) - 21, CGRectGetMaxY(self.passwordField.frame) + 54, CGRectGetWidth(self.view.frame) * 0.43, 58);
    }];
    [UIView animateWithDuration:.42 animations:^{
        self.signUpButton.frame = CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame) + 62, CGRectGetWidth(self.view.frame) * 0.33, 42);
    }];
}

- (void)animateLogInButtonPress {
    [UIView animateWithDuration:.1 animations:^{
        self.logInButton.frame = CGRectMake(CGRectGetMaxX(self.passwordField.frame) - (CGRectGetWidth(self.view.frame) * 0.43) + 21, CGRectGetMaxY(self.passwordField.frame) + 54, CGRectGetWidth(self.view.frame) * 0.43, 58);
    }];
    [UIView animateWithDuration:.42 animations:^{
        self.logInButton.frame = CGRectMake(CGRectGetMaxX(self.passwordField.frame) - (CGRectGetWidth(self.view.frame) * 0.33), CGRectGetMaxY(self.passwordField.frame) + 62, CGRectGetWidth(self.view.frame) * 0.33, 42);
    }];
}

- (void)convertSignUpToSuccess {
    [UIView animateWithDuration:0.4 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
        
        // enlarge sign up button into success button
        self.signUpButton.frame = CGRectMake((CGRectGetMinX(self.view.frame) + 50), (CGRectGetMinY(self.view.frame) + 300), (CGRectGetWidth(self.view.frame) - 100), (CGRectGetHeight(self.view.frame) - 600));
        self.signUpButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:42];
        [self.signUpButton setTitle:@"SUCCESS" forState:UIControlStateNormal];
    } completion:^(BOOL finished) {
        [NSThread sleepForTimeInterval:1];
        self.nowLogInLabel = [[UILabel alloc] init];
        self.nowLogInLabel.frame = CGRectMake(CGRectGetMinX(self.signUpButton.frame), CGRectGetMinY(self.signUpButton.frame) + (CGRectGetHeight(self.signUpButton.frame) / 2), CGRectGetWidth(self.signUpButton.frame), CGRectGetHeight(self.signUpButton.frame) / 2);
        self.nowLogInLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:23];
        self.nowLogInLabel.textAlignment = NSTextAlignmentCenter;
        self.nowLogInLabel.textColor = [UIColor whiteColor];
        self.nowLogInLabel.text = @"now log in";
        [self.view addSubview:self.nowLogInLabel];
    }];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    self.usernameField.text = @"";
}

#pragma mark - Parse

- (void)signUp {
    PFUser *user = [PFUser user];
    user.username = self.usernameField.text;
    user.password = self.passwordField.text;
    
            [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (self.signUpButton.tag == 2222) {
                }
                if (!error) {
                    // Hooray! Let them use the app now.
                    [self.signUpButton setTag:1111];
                    [self convertSignUpToSuccess];
                    
                    NSLog(@"success");
                    
                } else if (error.code == 100) {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lack Internet." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else if (error.code == 101) {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    
                    // invalid login parameters
                } else if (error.code == 202) {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"That username is taken." message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                } else if (error.code == 200) {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    
                    // missing username
                } else if (self.usernameField.text || self.passwordField.text == nil) {
                    NSLog(@"empty username or password field");
                } else {
                    NSString *errorString = [error userInfo][@"error"];
                    NSLog(@"%@", errorString);
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some other error." message:@"Check error log." delegate:nil cancelButtonTitle:@"YES SIR" otherButtonTitles:nil];
                    [alert show];
                }
            }];
    }

- (void)logIn {
    [PFUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"logged in successfully");
            // do stuff after successful login
            
            UINavigationController *navVC = [[UINavigationController alloc] init];
            [self presentViewController:navVC animated:YES completion:nil];
            QuestionsTableViewController *questionsVC = [[QuestionsTableViewController alloc] init];
            [navVC setViewControllers:@[questionsVC] animated:NO];
        } else {
            // the login failed. check error to see why
            
            self.passwordField.text = @"";
            self.verifyPasswordField.text = @"";
            if (!error) {
                // Hooray! Let them use the app now.
                [self.signUpButton setTag:1111];
                [self convertSignUpToSuccess];
            } else if (error.code == 100) {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"You lack Internet." message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            } else if (error.code == 101) {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                
                // invalid login parameters
            } else if (error.code == 200) {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                
                // missing username
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@", errorString);
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Some other error." message:@"Check error log." delegate:nil cancelButtonTitle:@"YES SIR" otherButtonTitles:nil];
                [alert show];
            }
        }
    }];
}


// offline login
//- (void)logIn {
//    UINavigationController *nav = [[UINavigationController alloc] init];
//    [self presentViewController:nav animated:YES completion:nil];
//    QuestionsTableViewController *questionsVC = [[QuestionsTableViewController alloc] init];
//    [nav setViewControllers:@[questionsVC] animated:NO];
//}

#pragma mark - Miscellaneous

- (BOOL)passwordMeetsRequirements:(NSString *)password {
        if (self.passwordField.text.length >= 6) {
            if (self.passwordField.text.length <= 20) {
                if (([self.passwordField.text containsString:@"a"] || [self.passwordField.text containsString:@"b"] || [self.passwordField.text containsString:@"c"] || [self.passwordField.text containsString:@"d"] || [self.passwordField.text containsString:@"e"] || [self.passwordField.text containsString:@"f"] || [self.passwordField.text containsString:@"g"] || [self.passwordField.text containsString:@"h"] || [self.passwordField.text containsString:@"i"] || [self.passwordField.text containsString:@"j"] || [self.passwordField.text containsString:@"k"] || [self.passwordField.text containsString:@"l"] || [self.passwordField.text containsString:@"m"] || [self.passwordField.text containsString:@"n"] || [self.passwordField.text containsString:@"o"] || [self.passwordField.text containsString:@"p"] || [self.passwordField.text containsString:@"q"] || [self.passwordField.text containsString:@"r"] || [self.passwordField.text containsString:@"s"] || [self.passwordField.text containsString:@"t"] || [self.passwordField.text containsString:@"u"] || [self.passwordField.text containsString:@"v"] || [self.passwordField.text containsString:@"w"] || [self.passwordField.text containsString:@"x"] || [self.passwordField.text containsString:@"y"] || [self.passwordField.text containsString:@"z"]) && ([self.passwordField.text containsString:@"0"] || [self.passwordField.text containsString:@"1"] || [self.passwordField.text containsString:@"2"] || [self.passwordField.text containsString:@"3"] || [self.passwordField.text containsString:@"4"] || [self.passwordField.text containsString:@"5"] || [self.passwordField.text containsString:@"6"] || [self.passwordField.text containsString:@"7"] || [self.passwordField.text containsString:@"8"] || [self.passwordField.text containsString:@"9"]) && ([self.passwordField.text containsString:@"~"] || [self.passwordField.text containsString:@"`"] || [self.passwordField.text containsString:@"!"] || [self.passwordField.text containsString:@"@"] || [self.passwordField.text containsString:@"#"] || [self.passwordField.text containsString:@"$"] || [self.passwordField.text containsString:@"%"] || [self.passwordField.text containsString:@"^"] || [self.passwordField.text containsString:@"&"] || [self.passwordField.text containsString:@"*"] || [self.passwordField.text containsString:@"("] || [self.passwordField.text containsString:@")"] || [self.passwordField.text containsString:@"-"] || [self.passwordField.text containsString:@"_"] || [self.passwordField.text containsString:@"+"] || [self.passwordField.text containsString:@"="] || [self.passwordField.text containsString:@"?"] || [self.passwordField.text containsString:@"."] || [self.passwordField.text containsString:@","] || [self.passwordField.text containsString:@"<"] || [self.passwordField.text containsString:@">"] || [self.passwordField.text containsString:@"/"] || [self.passwordField.text containsString:@":"] || [self.passwordField.text containsString:@";"] || [self.passwordField.text containsString:@"'"])) {
                    NSLog(@"your password met the requirements!");
                    return YES;
                } else {
                    NSLog(@"your password didn't meet the requirements");
                    return NO;
                }
            } else {
                return NO;
            }
        } else {
            return NO;
        }
}

- (void)tapFired:(UIGestureRecognizer *)sender {
    
    [self.view endEditing:YES];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame));
        self.logoLabel.frame = CGRectMake(CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetMidX(self.view.frame) - ((CGRectGetWidth(self.view.frame) * 0.75) / 2), CGRectGetWidth(self.view.frame) * 0.75, (CGRectGetWidth(self.view.frame) * 0.75) * 0.5);
    }];
    
    [UIView animateWithDuration:0.1 animations:^{
        self.nowLogInLabel.alpha = 0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            self.signUpButton.frame = CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame) + 62, CGRectGetWidth(self.view.frame) * 0.33, 42);
            self.signUpButton.titleLabel.font = [UIFont fontWithName:@"STHeitiSC-Medium" size:19];
            self.signUpButton.titleLabel.textColor = [UIColor whiteColor];
        } completion:^(BOOL finished) {
            return;
        }];
    }];
    
    // if tap on screen, hide verify text field and clear it out
    if (!self.verifyPasswordField.text.length) {
        [UIView animateWithDuration:.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.verifyPasswordField.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame), CGRectGetMinY(self.usernameField.frame) - 69, CGRectGetWidth(self.view.frame) * 0.75, 0);
            self.verifyPasswordLabel.frame = CGRectMake(CGRectGetMinX(self.verifyPasswordField.frame), CGRectGetMinY(self.verifyPasswordField.frame) - 40, CGRectGetWidth(self.verifyPasswordField.frame), 0);
            self.verifyPasswordLabel.text = @"";
        } completion:^(BOOL finished) {
            return;
        }];
    }
    
    // if requirements on screen, hide
    if (self.requirementsView.frame.origin.y < CGRectGetHeight(self.view.frame)) {
        [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:0 animations:^{
            self.requirementsView.frame = CGRectMake(CGRectGetMinX(self.usernameField.frame) - 10, CGRectGetMaxY(self.view.frame) + 200, CGRectGetWidth(self.usernameField.frame) + 30, (CGRectGetHeight(self.view.frame) - 400));
            self.requirementsTitleLabel.text = @"";
            self.requirementsLabel1.text = @"";
            self.requirementsLabel2.text = @"";
            self.requirementsLabel3.text = @"";
            self.requirementsLabel4.text = @"";
        } completion:^(BOOL finished) {
            return;
        }];
    }
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
