//
//  TimelineViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/8/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "TimelineViewController.h"
#import "Parse.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Post.h"
#import "instaPostCell.h"
#import "UIImageView+AFNetworking.h"
#import "ComposeViewController.h"
#import "postDetailsViewController.h"
#import "DateTools.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property NSArray *postArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
    
    [self refreshData];
    
}
-(void)refreshData{
    
    // construct PFQuery
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:@"createdAt"];
    [postQuery includeKey:@"author"];
    postQuery.limit = 20;
    
    // fetch data asynchronously
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.postArray = posts;
            [self.tableView reloadData];
            // do something with the data fetched
        }
        else {
            // handle error
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)didTapSignOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        // PFUser.current() will now be nil
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        appDelegate.window.rootViewController = loginViewController;
        
        // NSLog(@"User logged out successfully");
    }];
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    instaPostCell *cell = [tableView dequeueReusableCellWithIdentifier:@"instaPostCell" forIndexPath:indexPath];
    
    Post *post = self.postArray[indexPath.row];
    cell.post = post;

    NSString *formatted_date = post.createdAt.shortTimeAgoSinceNow;
    cell.datePosted.text = formatted_date;
    
    cell.authorUserNameHeader.text = post.author.username;
    cell.authorUserNameBody.text = post.author.username;
    cell.numberOfLikes.text = [NSString stringWithFormat:@"%@", post.likeCount];
    cell.postText.text = post.caption;
    
    if ([cell.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        cell.likeButton.selected = YES;
    } else {
        cell.likeButton.selected = NO;
    }
    
    PFFileObject *authorProfilePicture = post.author[@"profileImage"];
    NSURL *authorProfilePictureURL = [NSURL URLWithString:authorProfilePicture.url];
    cell.authorProfileImage.image = nil;
    [cell.authorProfileImage setImageWithURL:authorProfilePictureURL];
    
    NSString *postImageAddress = post.image.url;
    // NSLog(@"%@", post_image_address);
    NSURL *postImageURL = [NSURL URLWithString:postImageAddress];
    
    cell.postedImage.image = nil;
    [cell.postedImage setImageWithURL:postImageURL];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // cell.authorProfileImage =
    
    return cell;
}

- (void)didPost{
    [self refreshData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
     UINavigationController *navigationController = [segue destinationViewController];
    
    if ([segue.identifier  isEqual: @"postDetailSegue"]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postArray[indexPath.row];
        
        postDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
        
    } else if([segue.identifier  isEqual: @"composeSegue"]){
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    } else if([segue.identifier isEqual:@"postUserProfileSegue"]){
        
    }
}


@end
