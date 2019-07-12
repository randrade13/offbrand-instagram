//
//  instaCollectionCell.h
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/10/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

NS_ASSUME_NONNULL_BEGIN

@interface instaCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *postedImage;
@property (weak, nonatomic) IBOutlet UIImageView *userPostedImage;
@property (strong, nonatomic) Post *post;

@end

NS_ASSUME_NONNULL_END
