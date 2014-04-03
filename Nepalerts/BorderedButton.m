//
//  BorderedButton.m
//  Nepalerts
//
//  Created by Vikas Kumar on 01/04/14.
//  Copyright (c) 2014 Vikas kumar. All rights reserved.
//

#import "BorderedButton.h"

@implementation BorderedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews{
    [super layoutSubviews];
    self.layer.borderColor = [[UIColor blackColor] CGColor];
    self.layer.borderWidth = 1.0;
}

@end
