//
//  DataSource.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/18/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "DataSource.h"
#import <Parse/Parse.h>

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

#pragma mark - Posting

- (void)postQuestion:(NSString *)questionText withSuccess:(void (^)(BOOL succeeded))successBlock {
    PFObject *question = [PFObject objectWithClassName:@"Question"];
    
    question[@"text"] = questionText;
    
    // set asked by
    PFRelation *askedByRelation = [question relationForKey:@"askedBy"];
    [askedByRelation addObject:[PFUser currentUser]];

    [question saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (successBlock) {
            successBlock(succeeded);
        }
    }];
}

- (void)postAnswer:(NSString *)answerText withSuccess:(void (^)(BOOL succeeded))successBlock {
    PFObject *answer = [PFObject objectWithClassName:@"Answer"];
    
    answer[@"text"] = answerText;
    
    PFRelation *answerRelation = [self.question relationForKey:@"Answers"];
    [answerRelation addObject:answer];
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [self.question saveInBackgroundWithBlock:^(BOOL succeded, NSError *error) {
            if (successBlock) {
                successBlock(succeded);
                NSLog(@"question saved");
            }
        }];
    }];
    
    // set replied by to current user
    PFRelation *repliedByRelation = [answer relationForKey:@"repliedBy"];
    [repliedByRelation addObject:[PFUser currentUser]];
    
    [answer saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (successBlock) {
            successBlock(succeeded);
        }
    }];
}

- (void)postDescription:(NSString *)desciptionText forUser:(PFUser *)user withSuccess:(void (^)(BOOL))successBlock {
    user[@"description"] = desciptionText;
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (successBlock) {
            successBlock(succeeded);
        }
    }];
    
}

- (void)postProfilePic:(UIImage *)picture forUser:(PFUser *)user withSuccess:(void (^)(BOOL))successBlock {
    NSData *imageData = UIImagePNGRepresentation(picture);
    PFFile *imageFile = [PFFile fileWithData:imageData];

    [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (successBlock) {
            successBlock(succeeded);
            user[@"image"] = imageFile;
            [user saveInBackground];
            NSLog(@"posted pic successfully");
        }
    }];
}

#pragma mark - Fetching

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

- (void)answersForQuestion:(PFObject *)question withSuccess:(void (^)(NSArray *answers))successBlock {
    PFRelation *answersRelation = [question relationForKey:@"Answers"];

    [[answersRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (successBlock) {
                successBlock(objects);
            }
        }
    }];
}

- (void)usernameForQuestion:(PFObject *)question withSuccess:(void (^)(NSArray *user))successBlock {
    PFRelation *askedByRelation = [question relationForKey:@"askedBy"];
    
    [[askedByRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (successBlock) {
                successBlock(objects);
            }
        }
    }];
}

- (void)usernameForAnswer:(PFObject *)answer withSuccess:(void (^)(NSArray *user))successBlock {
    PFRelation *repliedByRelation = [answer relationForKey:@"repliedBy"];
    
    [[repliedByRelation query] findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (successBlock) {
                successBlock(objects);
            }
        }
    }];
}

//- (void)profilePicForUser:(PFUser *)user withSuccess:(void (^)(NSArray *photo))successBlock {
//    [user[@"image"] getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
//        if (!error) {
//            UIImage *picture = [UIImage imageWithData:data];
//
//        }
//    }];
//}

@end
