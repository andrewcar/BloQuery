//
//  User.m
//  BloQuery
//
//  Created by Andrew Carvajal on 6/3/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import "User.h"

@implementation User

- (instancetype)initWithClassName:(NSString * __nonnull)newClassName {
    self = [super initWithClassName:newClassName];
    if (self) {
        
    }
    return self;
}

- (NSString * __nonnull)parseClassName {
    return @"User";
}

@end
