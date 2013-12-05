//
//  TWPhotoCollectionViewCell.m
//  Thousand Words
//
//  Created by Mark Stuver on 12/3/13.
//  Copyright (c) 2013 Halo International Corp. All rights reserved.
//

#import "TWPhotoCollectionViewCell.h"

#define IMAGEVIEW_BORDER_LENGTH 5

@implementation TWPhotoCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setup];
    }
    return self;
}

/// Because we are using Storyboard, this method needs to be called in place of initWithFrame:
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self setup];
    }
    return self;
}


-(void)setup
{
    ///alloc and init the imageView property with initWithFrame: CGRectInset so that the imageView will be inset into the cell with a border based in the IMAGEVIEW_BORDER_LENGTH value
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, IMAGEVIEW_BORDER_LENGTH, IMAGEVIEW_BORDER_LENGTH)];
    /// contentView is the view of a cell that subviews can be set onto.
    [self.contentView addSubview:self.imageView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
