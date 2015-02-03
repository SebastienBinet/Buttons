//
//  IntelligentWall.m
//  Buttons
//
//  Created by Sebastien Binet on 12-01-18.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntelligentWall.h"

@interface IntelligentWall()

@property (weak, nonatomic) UIImageView* associatedWallImageView;

@end



@implementation IntelligentWall

@synthesize associatedWallImageView = _associatedWallImageView;


-(NSString *)description
{
    NSString *temp = [NSString stringWithFormat:@"(IntelligentWall(%p):(super:%@), (associatedWallImageView:%@),)", self, [super description], self.associatedWallImageView];
    return temp;
}

-(void)handleCollision
{
    self.velocity = CGPointMake( 0, 0);
}

-(id)initWithWallImageView:(UIImageView *)wallImageView
{
    
    CGRect tempRect = wallImageView.frame ;
    NSLog(@"wall frame is=%F,%F,  %F,%F", tempRect.origin.x, tempRect.origin.y, tempRect.size.width, tempRect.size.height);
    self = [super initWithFrame:tempRect];
    if (self) {
        self.associatedWallImageView = wallImageView;
        self.mass = INFINITY;
        self.velocity = CGPointMake( 0, 0);
    }
    return self;
    return self;    
}

-(void)updatePositionWithDeltaTime:(NSNumber*)deltaTime_NSNumber
{
    [super updatePositionWithDeltaTime:deltaTime_NSNumber];
    self.associatedWallImageView.frame = CGRectMake(super.frame.origin.x, super.frame.origin.y, super.frame.size.width, super.frame.size.height);
}



@end
