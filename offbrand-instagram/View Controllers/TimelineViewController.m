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
#import "postAuthorProfileViewController.h"

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate, ComposeViewControllerDelegate>

@property NSArray *postArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation TimelineViewController

static NSString *const POST_DATE_CREATED_KEY = @"createdAt";
static NSString *const POST_AUTHOR_KEY = @"author";
static NSString *const POST_AUTHOR_PROF_PIC_ID = @"profileImage";

static NSString *const MAIN_STORYBD_ID = @"Main";
static NSString *const LOGIN_VIEW_CONTROLLER_ID = @"LoginViewController";

static NSString *const INSTA_POST_CELL_ID = @"instaPostCell";

static NSString *const POST_AUTHOR_PROF_SEGUE_ID = @"postUserProfileSegue";
static NSString *const POST_DETAILS_SEGUE_ID = @"postDetailSegue";
static NSString *const COMPOSE_POST_SEGUE_ID = @"composeSegue";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self setupRefreshControl];
    [self refreshData];
}

-(void)setupRefreshControl{
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(refreshData) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:self.refreshControl atIndex:0];
}

-(void)refreshData{
    PFQuery *postQuery = [Post query];
    [postQuery orderByDescending:POST_DATE_CREATED_KEY];
    [postQuery includeKey:POST_AUTHOR_KEY];
    postQuery.limit = 20;
    
    [postQuery findObjectsInBackgroundWithBlock:^(NSArray<Post *> * _Nullable posts, NSError * _Nullable error) {
        if (posts) {
            self.postArray = posts;
            [self.tableView reloadData];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (IBAction)didTapSignOut:(id)sender {
    [PFUser logOutInBackgroundWithBlock:^(NSError * _Nullable error) {
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:MAIN_STORYBD_ID bundle:nil];
        LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:LOGIN_VIEW_CONTROLLER_ID];
        appDelegate.window.rootViewController = loginViewController;
    }];
}

- (NSInteger)tableView:(UITableView *)tableView  numberOfRowsInSection:(NSInteger)section {
    return self.postArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    instaPostCell *cell = [tableView dequeueReusableCellWithIdentifier:INSTA_POST_CELL_ID forIndexPath:indexPath];
    Post *post = self.postArray[indexPath.row];
    
    cell.post = post;
    cell.authorUserNameHeader.text = post.author.username;
    cell.authorUserNameBody.text = post.author.username;
    cell.numberOfLikes.text = [NSString stringWithFormat:@"%@", post.likeCount];
    cell.postText.text = post.caption;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    PFFileObject *authorProfilePicture = post.author[POST_AUTHOR_PROF_PIC_ID];
    NSURL *authorProfilePictureURL = [NSURL URLWithString:authorProfilePicture.url];
    cell.authorProfileImage.image = nil;
    [cell.authorProfileImage setImageWithURL:authorProfilePictureURL];
    [cell.authorProfileImage setUserInteractionEnabled:YES];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(didSelectUserProfileImage:)];
    [cell.authorProfileImage addGestureRecognizer:singleTap];
    
    NSString *postImageAddress = post.image.url;
    NSURL *postImageURL = [NSURL URLWithString:postImageAddress];
    cell.postedImage.image = nil;
    [cell.postedImage setImageWithURL:postImageURL];
    
    NSString *formattedDate = post.createdAt.shortTimeAgoSinceNow;
    cell.datePosted.text = formattedDate;
    
    if ([cell.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        cell.likeButton.selected = YES;
    } else {
        cell.likeButton.selected = NO;
    }
    return cell;
}

- (void)didSelectUserProfileImage:(id)sender {
    CGPoint location = [sender locationInView:self.tableView];
    self.indexPath = [self.tableView indexPathForRowAtPoint:location];
    [self performSegueWithIdentifier:POST_AUTHOR_PROF_SEGUE_ID sender:nil];
}

- (void)didPost{
    [self refreshData];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     UINavigationController *navigationController = [segue destinationViewController];
    
    if ([segue.identifier  isEqual: POST_DETAILS_SEGUE_ID]){
        UITableViewCell *tappedCell = sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:tappedCell];
        Post *post = self.postArray[indexPath.row];
        postDetailsViewController *postDetailsViewController = [segue destinationViewController];
        postDetailsViewController.post = post;
        
    } else if([segue.identifier  isEqual: COMPOSE_POST_SEGUE_ID]){
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
        
    } else if([segue.identifier isEqual:POST_AUTHOR_PROF_SEGUE_ID]){
        Post *post = self.postArray[self.indexPath.row];
        PFUser *postAuthor = post.author;
        postAuthorProfileViewController *authorProfile = [segue destinationViewController];
        authorProfile.selectedProfile = postAuthor;
    }
}

@end
