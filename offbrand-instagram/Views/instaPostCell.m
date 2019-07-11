//
//  instaPostCell.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/9/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "instaPostCell.h"

@implementation instaPostCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

/*
- (void)setPost:(Post *)post {
    _post = post;
    self.photoImageView.file = post[@"image"];
    [self.photoImageView loadInBackground];
}
*/
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)didTapLike:(id)sender {
    
    NSLog(@"Original Array%@", self.post.usersWhoLiked);
    if (![self.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        [self likePost];
        
    } else{
        [self unlikePost];
    }
}

- (void)likePost{
    
    self.post.usersWhoLiked = [self.post.usersWhoLiked arrayByAddingObject:[PFUser currentUser].objectId];
    self.post.likeCount = @(self.post.likeCount.integerValue + 1);
    self.likeButton.selected = YES;
    
    // reload fav count data
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    [self.post saveInBackground];
}

- (void)unlikePost{
    NSMutableArray *deletionArray = [NSMutableArray arrayWithArray:self.post.usersWhoLiked];
    [deletionArray removeObject:[PFUser currentUser].objectId];
    NSLog(@"DeletionArray %@", deletionArray);
    self.post.usersWhoLiked = [NSArray arrayWithArray:deletionArray];
    self.post.likeCount = @(self.post.likeCount.integerValue - 1);
    self.likeButton.selected = NO;
    
    // reload fav count data
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    [self.post saveInBackground];
}

@end
