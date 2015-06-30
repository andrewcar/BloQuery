//
//  DataSource.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/18/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@class Media;

typedef void (^NewItemCompletionBlock)(NSError *error);

@interface DataSource : NSObject

@property (nonatomic, strong) NSMutableArray *listOfQuestions;
@property (nonatomic, strong) NSMutableArray *listOfAnswers;
@property (nonatomic, assign) CGFloat numberOfQuestions;
@property (nonatomic, assign) CGFloat numberOfAnswers;

+ (instancetype)sharedInstance;

- (void)postQuestion:(NSString *)questionText;

- (void)populateListOfQuestions:(void (^)(NSArray *questions))successBlock;

@end
