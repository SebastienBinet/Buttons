//
//  ScreenObject.h
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Helpers.h"

@interface ScreenObject : NSObject
@property (nonatomic) CGRect frame; // rectangle in superview that completely includes the button.
@property (nonatomic) CGFloat mass; // grams
@property (nonatomic) CGPoint velocity; // vertex of m/s
@property (nonatomic) CGPoint velocityAfterCollision; // vertex of m/s


-(void)checkAndHandleButtonPress:(id)button;
-(void)checkAndHandleCollisionWithObject:(ScreenObject*)otherScreenObject;
-(NSString *)description;
//-(CGPoint)GetNormaleAtPoint:(CGPoint)contactPoint;
-(void)evaluateCollisionEffectOnEdge:(Edge)edge withObject:(ScreenObject*)otherScreenObject;
-(void)applyCollisionEffectOnEdge:(Edge)edge withObject:(ScreenObject*)otherScreenObject;
-(id)initWithFrame:(CGRect)frame;
-(float)scoreImpact;
-(void)updatePositionWithDeltaTime:(NSNumber *)deltaTime_NSNumber;
-(Edge)whichEdgeWasThisCollision:(CGRect)framesIntersection;


//+(void)updateVelocityIfThereIsCollisionBetween:(id)object1 And:(id)object2; 




@end
