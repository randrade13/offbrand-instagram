//
//  postAuthorProfileViewController.h
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/11/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Parse.h"

NS_ASSUME_NONNULL_BEGIN

@interface postAuthorProfileViewController : UIViewController
@property (strong, nonatomic) PFUser *selectedProfile;
@end

NS_ASSUME_NONNULL_END
