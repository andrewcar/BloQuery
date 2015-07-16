//
//  ProfileViewController.h
//  BloQuery
//
//  Created by Andrew Carvajal on 7/11/15.
//  Copyright (c) 2015 andrewcar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDTakeController.h"

@interface ProfileViewController : UIViewController <FDTakeDelegate>

@property FDTakeController *takeController;
- (void)takePhotoOrChooseFromLibrary;
- (void)editingSwitchToggled:(id)sender;

@end
