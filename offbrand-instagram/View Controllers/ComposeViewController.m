//
//  ComposeViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/9/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "ComposeViewController.h"
#import "UITextView+Placeholder.h"
#import "TimelineViewController.h"
#import "MBProgressHUD.h"

@interface ComposeViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *postImage;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;

@end

@implementation ComposeViewController

static NSString *const PHOTO_DESCRIPTION_PLACEHOLDER = @"Write a description for your photo!";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupComposeViewController];
}

- (void)setupComposeViewController {
    self.textView.delegate = self;
    self.textView.placeholder = PHOTO_DESCRIPTION_PLACEHOLDER;
    self.textView.placeholderColor = [UIColor lightGrayColor];
}

- (UIImage *)resizeImage:(UIImage *)image withSize:(CGSize)size {
    UIImageView *resizeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    resizeImageView.contentMode = UIViewContentModeScaleAspectFill;
    resizeImageView.image = image;
    
    UIGraphicsBeginImageContext(size);
    [resizeImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.originalImage = info[UIImagePickerControllerOriginalImage];
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(1000, 1000)];
    [self.postImage setImage:self.editedImage];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapPostImage:(id)sender {
    UIImagePickerController *imagePickerVC = [UIImagePickerController new];
    imagePickerVC.delegate = self;
    imagePickerVC.allowsEditing = YES;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        imagePickerVC.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [self presentViewController:imagePickerVC animated:YES completion:nil];
}

- (IBAction)didTapCancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapShare:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Post postUserImage:self.editedImage withCaption:self.textView.text withCompletion:nil];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self dismissViewControllerAnimated:true completion:^{
        [self.delegate didPost];
    }];
}

- (IBAction)didTapPostView:(id)sender {
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
