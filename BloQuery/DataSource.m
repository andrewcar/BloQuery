//
//  DataSource.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/18/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "DataSource.h"

@implementation DataSource

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
    }
    return self;
}

- (void)postQuestion:(NSString *)questionText {
    PFObject *question = [PFObject objectWithClassName:@"Question"];
    
    question[@"text"] = questionText;
    question[@"postedBy"] = [PFUser currentUser].username;
    
    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"question post succeeded");
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QUESTION POST SAVED" message:nil delegate:nil cancelButtonTitle:@"FUCK" otherButtonTitles:@"YES", nil];
            [alert show];
        } else {
            NSLog(@"question post failed");
        }
    }];
}

- (void)populateListOfQuestions:(void (^)(NSArray *questions))successBlock {
    PFQuery *questionQuery = [PFQuery queryWithClassName:@"Question"];
    
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.listOfQuestions = [objects mutableCopy];
            if (successBlock) {
                successBlock(self.listOfQuestions);
            }
        }
    }];
}

@end
