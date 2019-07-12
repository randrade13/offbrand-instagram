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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)didTapLike:(id)sender {
    if (![self.post.usersWhoLiked containsObject:[PFUser currentUser].objectId]){
        [self likePost];
    } else {
        [self unlikePost];
    }
}

- (void)likePost{
    self.post.usersWhoLiked = [self.post.usersWhoLiked arrayByAddingObject:[PFUser currentUser].objectId];
    self.post.likeCount = @(self.post.likeCount.integerValue + 1);
    self.likeButton.selected = YES;
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    [self.post saveInBackground];
}

- (void)unlikePost{
    NSMutableArray *deletionArray = [NSMutableArray arrayWithArray:self.post.usersWhoLiked];
    [deletionArray removeObject:[PFUser currentUser].objectId];
    self.post.usersWhoLiked = [NSArray arrayWithArray:deletionArray];
    self.post.likeCount = @(self.post.likeCount.integerValue - 1);
    self.likeButton.selected = NO;
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    [self.post saveInBackground];
}

@end
