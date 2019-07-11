//
//  postDetailsViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/9/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "postDetailsViewController.h"
#import "DateTools.h"

@interface postDetailsViewController ()

@end

@implementation postDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupDetailsViewWithPost];
}

- (void)setupDetailsViewWithPost{
    
    self.authorUserName.text = self.post.author.username;
    self.postText.text = self.post.caption;
    self.numberOfLikes.text = [NSString stringWithFormat:@"%@", self.post.likeCount];
    
    NSString *formatted_date = self.post.createdAt.timeAgoSinceNow;
    self.datePosted.text = formatted_date;
    
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
