//
//  DataSource.h
//  BloQuery
//
//  Created by Andrew Carvajal on 6/1/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataSource : NSObject

@property (nonatomic, strong, readonly) NSString *accessToken;

+ (instancetype)sharedInstance;

@end
