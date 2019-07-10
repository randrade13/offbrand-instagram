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

@end
