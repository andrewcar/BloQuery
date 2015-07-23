//
//  DataSource.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/18/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Parse/Parse.h"

@import UIKit;

@class Media;

typedef void (^NewItemCompletionBlock)(NSError *error);

@interface DataSource : NSObject

@property (nonatomic, strong) PFObject *question;
@property (nonatomic, strong) NSMutableArray *listOfQuestions;

+ (instancetype)sharedInstance;

#pragma mark - Posting

- (void)postQuestion:(NSString *)questionText withSuccess:(void (^)(BOOL succeeded))successBlock;

- (void)postAnswer:(NSString *)answerText withSuccess:(void (^)(BOOL succeeded))successBlock;

- (void)postDescription:(NSString *)desciptionText forUser:(PFUser *)user withSuccess:(void (^)(BOOL succeeded))successBlock;

- (void)postProfilePic:(UIImage *)picture forUser:(PFUser *)user withSuccess:(void (^)(BOOL))successBlock;

- (void)toggleLikeForAnswer:(PFObject *)answerPost withSuccess:(void (^)(BOOL))successBlock;

#pragma mark - Fetching

- (void)populateListOfQuestions:(void (^)(NSArray *questions))successBlock;

- (void)answersForQuestion:(PFObject *)question withSuccess:(void (^)(NSArray *answers))successBlock;

- (void)usernameForQuestion:(PFObject *)question withSuccess:(void (^)(NSArray *user))successBlock;

- (void)usernameForAnswer:(PFObject *)answer withSuccess:(void (^)(NSArray *user))successBlock;

- (void)likesForAnswer:(PFObject *)answer withSuccess:(void (^)(NSArray *likes))successBlock;

@end
