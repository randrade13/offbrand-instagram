//
//  ComposeViewController.h
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/9/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Post.h"

@protocol ComposeViewControllerDelegate
- (void)didPost;
@end

NS_ASSUME_NONNULL_BEGIN

@interface ComposeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (nonatomic, weak) id<ComposeViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
