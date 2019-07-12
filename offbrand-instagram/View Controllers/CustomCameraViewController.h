//
//  CustomCameraViewController.h
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/11/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class CustomCameraViewController;
@protocol CustomCameraViewControllerDelegate <NSObject>
- (void) selectPhotoWithCustomCamera:(UIImage *)selectedImage;

@end

@interface CustomCameraViewController : UIViewController
@property (weak, nonatomic) id<CustomCameraViewControllerDelegate> delegate;
@property (strong, nonatomic) UIImage *selectedImage;

@end

NS_ASSUME_NONNULL_END
