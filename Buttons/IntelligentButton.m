//
//  IntelligentButton.m
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IntelligentButton.h"



@interface IntelligentButton()
@property (weak, nonatomic) UIButton* associatedButton;
@property (nonatomic) ButtonState buttonState; 


@end


@implementation IntelligentButton

@synthesize associatedButton = _associatedButton;
@synthesize buttonState = _buttonState;



-(void)applyCollisionEffectOnEdge:(Edge)edge withObject:(ScreenObject*)otherScreenObject
{
    [super applyCollisionEffectOnEdge:edge withObject:otherScreenObject];
    self.buttonState = (self.buttonState==BUTTON_STATE_UP)?BUTTON_STATE_DOWN:BUTTON_STATE_UP;
}

-(void)checkAndHandleButtonPress:(id)button
{
    if (button == self.associatedButton) {
        self.buttonState = (self.buttonState==BUTTON_STATE_UP)?BUTTON_STATE_DOWN:BUTTON_STATE_UP;
        
        BOOL isHighlighted = self.associatedButton.highlighted;
        isHighlighted = !isHighlighted;
        self.associatedButton.highlighted = isHighlighted;
        //self.associatedButton.frame = CGRectMake(self.associatedButton.frame.origin.x,self.associatedButton.frame.origin.y,self.associatedButton.frame.size.width*1.5,self.associatedButton.frame.size.height*1.5);
    }
}


-(NSString *)description
{
    NSString *temp = [NSString stringWithFormat:@"(IntelligentButton(%p):(super:%@), (associatedButton:%@), (buttonState=%@))", self, [super description], self.associatedButton, (self.buttonState==BUTTON_STATE_UP)?@"UP":@"DOWN"];
    return temp;
}


-(id)initWithButton:(UIButton *)button
{
    CGRect tempRect = button.frame;
    NSLog(@"button frame is=%F,%F,  %F,%F", tempRect.origin.x, tempRect.origin.y, tempRect.size.width, tempRect.size.height);
    self = [super initWithFrame:button.frame];
    if (self) {
        self.associatedButton = button;
        self.buttonState = BUTTON_STATE_UP;
    }
    return self;
}

// TBD: check if this read-only protection is required.
//-(void)setBounds:(CGRect)bounds
//{
//    self.bounds = bounds;     
//}

-(float)scoreImpact
{
    return ((self.buttonState==BUTTON_STATE_UP)?1:-1)*self.mass;
}

-(void)updatePositionWithDeltaTime:(NSNumber*)deltaTime_NSNumber
{
    [super updatePositionWithDeltaTime:deltaTime_NSNumber];
    self.associatedButton.frame = CGRectMake(super.frame.origin.x, super.frame.origin.y, super.frame.size.width, super.frame.size.height);
    self.associatedButton.highlighted = (self.buttonState==BUTTON_STATE_DOWN);
}



@end
