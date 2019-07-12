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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadUserProfilePicture];
    
    NSString *userName = self.selectedProfile.username;
    self.userProfileName.text = userName;
    
    UICollectionViewFlowLayout *layout = (UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout;
    
    layout.minimumInteritemSpacing = 3;
    layout.minimumLineSpacing = 3;
    CGFloat postersPerLine = 3;
    CGFloat itemWidth = (self.collectionView.frame.size.width - layout.minimumInteritemSpacing * (postersPerLine - 1)) / postersPerLine;
    CGFloat itemHeight = itemWidth;
    layout.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    [self refreshData];
    // Do any additional setup after loading the view.
}

-(void)loadUserProfilePicture{
    PFFileObject *PFObjectProfileImage = self.selectedProfile[@"profileImage"];
    
    NSURL *profileImageURL = [NSURL URLWithString:PFObjectProfileImage.url];
    self.userProfilePicture.image = nil;
    [self.userProfilePicture setImageWithURL:profileImageURL];
}

-(void)refreshData{
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery whereKey:@"author" equalTo:self.selectedProfile];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.userPostArray = posts;
            [self.collectionView reloadData];
            // do something with the data fetched
        }
        else {
            // handle error
        }
    }];
}

- (nonnull __kindof UICollectionViewCell *)collectionView:(nonnull UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    instaCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"instaCollectionCell" forIndexPath:indexPath];
    
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier  isEqual: @"postDetailSegue"]){
        
        UICollectionViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:tappedCell];
        Post *post = self.userPostArray[indexPath.row];
        
        postDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
    }
}


@end
