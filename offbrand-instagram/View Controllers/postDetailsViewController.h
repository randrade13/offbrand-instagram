//
//  postDetailsViewController.h
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/9/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface postDetailsViewController : UIViewController

@property(strong, nonatomic) Post *post;
@property (weak, nonatomic) IBOutlet UIImageView *authorProfileImage;
@property (weak, nonatomic) IBOutlet UILabel *authorUserName;
@property (weak, nonatomic) IBOutlet UILabel *postText;
@property (weak, nonatomic) IBOutlet UILabel *datePosted;
@property (weak, nonatomic) IBOutlet UILabel *numberOfLikes;

@end

NS_ASSUME_NONNULL_END
