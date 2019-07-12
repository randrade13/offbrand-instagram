//
//  ProfileViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/10/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "ProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "postDetailsViewController.h"
#import "instaCollectionCell.h"
#import "Post.h"
#import "Parse.h"
#import "AppDelegate.h"

@interface ProfileViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UILabel *userProfileName;
@property (weak, nonatomic) IBOutlet UIImageView *profilePicture;
@property (strong, nonatomic) UIImage *originalImage;
@property (strong, nonatomic) UIImage *editedImage;
@property NSArray *userPostArray;

@end

@implementation ProfileViewController

static NSString *const POST_DATE_CREATED_KEY = @"createdAt";
static NSString *const POST_AUTHOR_KEY = @"author";
static NSString *const USER_PROF_PIC_KEY = @"profileImage";

static NSString *const POST_COLLECTION_CELL_ID = @"instaCollectionCell";
static NSString *const POST_DETAILS_SEGUE_ID = @"postDetailSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUserProfilePicture];
    [self setupProfileViewController];
    [self setupCollectionView];
    [self refreshData];
}

-(void)setupProfileViewController{
    NSString *userName = PFUser.currentUser.username;
    self.userProfileName.text = userName;
}

-(void)setupCollectionView{
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
}

-(void)loadUserProfilePicture{
    PFFileObject *PFObjectProfileImage = [PFUser currentUser][USER_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.profilePicture.image = nil;
    [self.profilePicture setImageWithURL:profileImageURL];
}

-(void)refreshData{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:POST_DATE_CREATED_KEY];
    [postQuery whereKey:POST_AUTHOR_KEY equalTo:[PFUser currentUser]];
    [postQuery includeKey:POST_AUTHOR_KEY];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.userPostArray = posts;
            [self.collectionView reloadData];
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    instaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:POST_COLLECTION_CELL_ID forIndexPath:indexPath];
    Post *post = self.userPostArray[indexPath.row];
    cell.post = post;
    
    NSString *post_image_address = post.image.url;
    NSURL *postImageURL = [NSURL URLWithString:post_image_address];
    cell.postedImage.image = nil;
    [cell.postedImage setImageWithURL:postImageURL];
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPostArray.count;
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
    self.editedImage = [self resizeImage:self.originalImage withSize:CGSizeMake(400, 400)];
    [self.profilePicture setImage:self.editedImage];
    
    [PFUser currentUser][USER_PROF_PIC_KEY] = [Post getPFFileFromImage:self.editedImage];
    [[PFUser currentUser] saveInBackground];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapChangeProfilePicture:(id)sender {
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: POST_DETAILS_SEGUE_ID]){
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        
        Post *post = self.userPostArray[indexPath.row];
        postDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
}

@end
