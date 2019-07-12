//
//  postAuthorProfileViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/11/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "postAuthorProfileViewController.h"
#import "UIImageView+AFNetworking.h"
#import "postDetailsViewController.h"
#import "instaCollectionCell.h"
#import "Post.h"
#import "AppDelegate.h"

@interface postAuthorProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *userProfileName;
@property (weak, nonatomic) IBOutlet UIImageView *userProfilePicture;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property NSArray *userPostArray;

@end

@implementation postAuthorProfileViewController

static NSString *const POST_DATE_CREATED_KEY = @"createdAt";
static NSString *const POST_AUTHOR_KEY = @"author";
static NSString *const POST_AUTHOR_PROF_PIC_KEY = @"profileImage";

static NSString *const POST_COLLECTION_CELL_ID = @"instaCollectionCell";
static NSString *const POST_DETAILS_SEGUE_ID = @"postDetailSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUserProfilePicture];
    [self setupPostAuthorView];
    [self setupCollectionView];
    [self refreshData];
}
-(void)setupPostAuthorView{
    NSString *userName = self.selectedProfile.username;
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
    PFFileObject *PFObjectProfileImage = self.selectedProfile[POST_AUTHOR_PROF_PIC_KEY];
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.userProfilePicture.image = nil;
    [self.userProfilePicture setImageWithURL:profileImageURL];
}

-(void)refreshData{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:POST_DATE_CREATED_KEY];
    [postQuery whereKey:POST_AUTHOR_KEY equalTo:self.selectedProfile];
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
    cell.userPostedImage.image = nil;
    [cell.userPostedImage setImageWithURL:postImageURL];
    
    return cell;
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.userPostArray.count;
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
