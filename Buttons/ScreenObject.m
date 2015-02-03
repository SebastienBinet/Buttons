//
//  ScreenObject.m
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


// symbols in this code:
//  [a]: complete vector (a.x, a.y, a.z). Has a length and a direction.
//  |a|: length of [a]: positive scalar or 0
//  ^a^: direction of [a]. This is equal to [a] / |a|

#import "ScreenObject.h"
#import "Helpers.h"


@interface ScreenObject()



//+(BOOL)IsThereCollisionBetween:(ScreenObject*)Object1 And:(ScreenObject*)Object2;
//+(CGPoint)GetContactPointBetween:(ScreenObject*)Object1 And:(ScreenObject*)Object2;

-(BOOL)isThereACollisionWith:(ScreenObject*)Object2;

@end




@implementation ScreenObject
@synthesize frame = _frame;
@synthesize mass = _mass;
@synthesize velocity = _velocity;
@synthesize velocityAfterCollision = _velocityAfterCollision;


-(void)checkAndHandleButtonPress:(id)button
{
    ;
}


-(void)checkAndHandleCollisionWithObject:(ScreenObject*)otherScreenObject
{
    // Check for collision
    // Get frame of first object
    CGRect frameObj0 = self.frame;
    // Get frame of second object
    CGRect frameObj1 = otherScreenObject.frame;
    
    // Find collision point on screen
    CGRect framesIntersection = CGRectIntersection(frameObj0, frameObj1);
    
    
    if ( ! CGRectIsNull ( framesIntersection) ) {
        
        NSLog(@"-----------------------------------------------------------");
        NSLog(@"Collision between Object(%p) and Object(%p)", self, otherScreenObject);
        // Find collision point on both objects
        // TBD call objects method
        
        // As a first estimation, find the frame edge on which the collision occurred
        Edge IntersectionEdgeOnThisObj = [self whichEdgeWasThisCollision:framesIntersection];
        Edge IntersectionEdgeOnOtherObject = (IntersectionEdgeOnThisObj==EDGE_UP?EDGE_DOWN:(IntersectionEdgeOnThisObj==EDGE_DOWN?EDGE_UP:(IntersectionEdgeOnThisObj==EDGE_LEFT?EDGE_RIGHT:(IntersectionEdgeOnThisObj==EDGE_RIGHT?EDGE_LEFT:-1))));
        
        // Find effect on this object.
        [self evaluateCollisionEffectOnEdge:IntersectionEdgeOnThisObj withObject:otherScreenObject];
        
        // Find effect on other object.
        [otherScreenObject evaluateCollisionEffectOnEdge:IntersectionEdgeOnOtherObject withObject:self];

        // Apply effect on this object.
        [self applyCollisionEffectOnEdge:IntersectionEdgeOnThisObj withObject:otherScreenObject];
        
        // Apply effect on other object.
        [otherScreenObject applyCollisionEffectOnEdge:IntersectionEdgeOnOtherObject withObject:self];
    }
}

-(NSString *)description
{
    NSString *temp = [NSString stringWithFormat:@"(ScreenObject(%p):(frame=%4.0F,%4.0F,%4.0F,%4.0F), (mass=%5.1F), (velocity=%5.1F,%5.1F), (velocityAfterCollision=%5.1F,%5.1F))", self, self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height, self.mass, self.velocity.x,self.velocity.y, self.velocityAfterCollision.x,self.velocityAfterCollision.y ];
    return temp;
}

// TBD: add arguments to reflect the collision effect (direction, force)
//-(void)handleCollision
//{
//    self.velocity = CGPointMake( randFloat(-5,10), randFloat(-10,10));
//}


-(void)evaluateCollisionEffectOnEdge:(Edge)edge withObject:(ScreenObject*)otherScreenObject
{
    CGFloat v1;  // velocityInAffectedDirection;             
    CGFloat v2;  // velocityOtherObjectInAffectedDirection;  
    CGFloat v1p; // velocityInAffectedDirection_prime;       
    CGFloat m1 = self.mass;
    CGFloat m2 = otherScreenObject.mass;
    
    
    switch (edge) {
        case EDGE_DOWN:
        case EDGE_UP:
            v1 = self.velocity.y;
            v2 = otherScreenObject.velocity.y;
            break;
            
        case EDGE_LEFT:
        case EDGE_RIGHT:
            v1 = self.velocity.x;
            v2 = otherScreenObject.velocity.x;
            break;
            
        default:
            assert(1000);
            break;
    }
    
    // New velocity this object in affected direction
    //       ( m1 - m2 ) * v1   +   2 * m2 * v2
    // v1' = ---------------------------------
    //                      m1 + m2    
    
    // Handle walls
    if (m1 == INFINITY) {
        v1p = v1; // do not change this velocity
    }
    else if (m2 == INFINITY) {
        // total rebound
        
        // Protection against wall penetration
        switch (edge) {
            case EDGE_DOWN: // means wall is down of this object
            case EDGE_RIGHT:
                if (v1 > 0) {
                    v1p = - v1;
                }
                else {  // protection
                    v1p = v1;
                }
                break;
                
            case EDGE_LEFT:
            case EDGE_UP:
                if (v1 < 0) {
                    v1p = - v1;
                }
                else {  // protection
                    v1p = v1;
                }
                break;
                
            default:
                assert(1001);
                break;
        }

    }
    else { // all normal cases
        v1p =  ( ( m1 - m2 ) * v1   +   2 * m2 * v2 ) / ( m1 + m2 );
    }
    switch (edge) {
        case EDGE_DOWN:
        case EDGE_UP:
            self.velocityAfterCollision = CGPointMake(self.velocity.x, v1p);
            break;
            
        case EDGE_LEFT:
        case EDGE_RIGHT:
            self.velocityAfterCollision = CGPointMake(v1p, self.velocity.y);
            break;
            
        default:
            assert(1002);
            break;
            
    }

}


-(void)applyCollisionEffectOnEdge:(Edge)edge withObject:(ScreenObject*)otherScreenObject
{
    self.velocity = CGPointMake(self.velocityAfterCollision.x, self.velocityAfterCollision.y);
    self.velocityAfterCollision = CGPointMake(NAN, NAN);
    
    // protection against object overlapping
    self.frame = CGRectOffset(self.frame, self.velocity.x * FRAME_REFRESH_PERIOD, self.velocity.y * FRAME_REFRESH_PERIOD);

}


-(id)init
{
    self = [super init];
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    self = [self init];
    if (self) {
        self.frame = frame; //CGRectMake(100, 100, 120, 120);
        float frameArea = frame.size.width * frame.size.height;
        self.mass = frameArea / 1000;
        self.velocity = CGPointMake( randFloat(-100,100), randFloat(-100,100));
    }
    return self;
}


-(BOOL)isThereACollisionWith:(ScreenObject*)Object2
{
    // always need to be overiden.
    return NO;
}


-(float)scoreImpact
{
    // to be overidden
    return 0.0f;
}


-(void)updatePositionWithDeltaTime:(NSNumber*)deltaTime_NSNumber
{
    NSTimeInterval deltaTime_float = [deltaTime_NSNumber floatValue];
    self.frame = CGRectOffset(self.frame, self.velocity.x * deltaTime_float, self.velocity.y * deltaTime_float);
    
}

//+(void)updateVelocityIfThereIsCollisionBetween:(ScreenObject *)Object1 And:(ScreenObject *)Object2
//{
//    BOOL collision = [ScreenObject IsThereCollisionBetween:Object1 And:Object2];
//    if (collision) {
//        // Calculate contact point 
//        CGPoint ContactPoint = [ScreenObject GetContactPointBetween:Object1 And:Object2];
//        // Calculate normale of the contact point
//        CGPoint NormaleObject1 = [Object1 GetNormaleAtPoint:ContactPoint];
//        CGPoint NormaleObject2 = [Object2 GetNormaleAtPoint:ContactPoint];
//        CGPoint NormaleAverage1 = CGPointMake( (NormaleObject1.x - NormaleObject2.x) / 2, (NormaleObject1.y- NormaleObject2.y) / 2 );
//
//        // First equation
//        // Qty of Movement conservation (p)
//        //      p1' +     p2'  =       p1 +      p2    
//        // m1*[v1]' + m2*[v2]' =  m1*[v1] + m2*[v2]
//        // m1*[v1]'            =  m1*[v1] + m2*[v2] - m2*[v2]'
//        // m1*[v1]'            =  m1*[v1] + m2*([v2] - [v2]')
//        //    [v1]'            = (m1*[v1] + m2*([v2] - [v2]') / m1
//        
//        // Second equation
//        // Cinetic energy conservation
//        // m1*|v1|'^2 + m2*|v2|'^2 =         m1*|v1|^2 + m2*|v2|^2
//        //              m2*|v2|'^2 =         m1*|v1|^2 + m2*|v2|^2 - m1*|v1|'^2
//        //                 |v2|'^2 =        (m1*|v1|^2 + m2*|v2|^2 - m1*|v1|'^2) / m2
//        //                 |v2|'   =  SQRT( (m1*|v1|^2 + m2*|v2|^2 - m1*|v1|'^2) / m2
//        
//        // See https://docs.google.com/viewer?a=v&q=cache:ZnAwtPmqOgoJ:www.cmontmorency.qc.ca/~mperiard/Rotation_cinematique.ppt+resolution+collision+élastique&hl=fr&gl=ca&pid=bl&srcid=ADGEESjAslvyCHtFIPLywfN9hwXqxwTrTCcl9u2_TwXdkrLYjs9dENaC2_IJ1-EFfLKHwwea4RvUIW_nBWjoz0wKa-Pn-zTECSnI1m-c5WginwUx2za6NbKcyrizDojuSnPC0YKOepDC&sig=AHIEtbQIrsjaIr68nLPo2F6lxXvmj2tHTg
//        
//        // TBD complete this function correctly
//        
//        CGPoint velocityNewObject1 = /*TBD*/ CGPointMake(-Object1.velocity.x, -Object1.velocity.y);
//        CGPoint velocityNewObject2 = /*TBD*/ CGPointMake(-Object2.velocity.x, -Object2.velocity.y);
//    }
//}

-(Edge)whichEdgeWasThisCollision:(CGRect)framesIntersection
{
    // Find in which quadran is the center of the frame intersection
    
    //    *: frame of this object
    //    -: frame of the second object
    //    #: intersection zone
    //    \: top-left to bottom-right of the frame
    //    1: offset from enter to top-right corner of this frame is (17,9) -> frameXdivY = 17/9 = 1.88
    //
    //    2: EDGE_RIGHT: offset of the center of the frame intersection is (14,-6) -> offsetXdivY = 14/-6 = -2.33
    //    3: EDGE_RIGHT:example with offset of (  4, 0) -> offsetXdivY = INFINITE
    //    4: EDGE_RIGHT:example with offset of ( 14, 6) -> offsetXdivY = 2.33
    //
    //    5: EDGE_DOWN: example with offset of ( 11, 7) -> offsetXdivY = 1.57
    //    6: EDGE_DOWN: example with offset of (  0, 3) -> offsetXdivY = 0
    //    7: EDGE_DOWN: example with offset of (-11, 7) -> offsetXdivY = -1.57
    //
    //    8: EDGE_LEFT: example with offset of (-14, 6) -> offsetXdivY = -2.33
    //    9: EDGE_LEFT: example with offset of (-15, 0) -> offsetXdivY = -INFINITE
    //   10: EDGE_LEFT: example with offset of (-14,-6) -> offsetXdivY = 2.33
    //
    //   11: EDGE_UP:   example with offset of ( -9,-7) -> offsetXdivY = 1.28
    //   12: EDGE_UP:   example with offset of (  0,-7) -> offsetXdivY = 0
    //   13: EDGE_UP:   example with offset of (  9,-7) -> offsetXdivY = -1.28
    //
    //                                +----------------------------------------+
    //     -----> x                   |                                        |
    //   | ***************************#######                                  |
    //   | * \            TOP         #   / #                                  |
    //   | *   \ 11       12       13 # /   #                                  |
    //   | * 10  \                    #  2  #                                  |
    //   v *       \                / #     #                                  |
    //     *         \            /   #     #                                  |
    //   y *           \        /     #######----------------------------------+
    //     *             \    /             *
    //     *LEFT           \/  3       RIGHT*
    //     * 9             /\               *
    //     *             /    \             *
    //     *           /   6    \           *
    //     *         /            \         *
    //     *       /                \       *
    //     *  8  /                    \  4  *
    //     *   / 7                    5 \   *
    //     * /           BOTTOM           \ *
    //     *********************************1
    
    
    Edge returnValue = EDGE_DOWN;
    CGPoint framesIntesectionCenter = CGPointMake( framesIntersection.origin.x + (framesIntersection.size.width)/2, framesIntersection.origin.y + (framesIntersection.size.height)/2);
    NSLog(@" ");
    NSLog(@"Object(%p) = %@",self, self);
    NSLog(@" ");
    NSLog(@"framesIntersection = (%5.1F, %5.1F, %5.1F, %5.1F)",framesIntersection.origin.x, framesIntersection.origin.y, framesIntersection.size.width, framesIntersection.size.height);
    CGPoint frameCenter = CGPointMake( self.frame.origin.x + (self.frame.size.width)/2, self.frame.origin.y + (self.frame.size.height)/2);
    CGPoint intersectionOffsetComparedToFrameCenter = CGPointMake(framesIntesectionCenter.x - frameCenter.x, framesIntesectionCenter.y - frameCenter.y);
    CGPoint frameBottonRightOffsetComparedToCenterFrame = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    if (frameBottonRightOffsetComparedToCenterFrame.y != 0) {// avoid division by zero
        float frameXdivY = frameBottonRightOffsetComparedToCenterFrame.x / frameBottonRightOffsetComparedToCenterFrame.y;
        if (intersectionOffsetComparedToFrameCenter.y > 0) { // cases 4,5,6,7,8
            float offsetXdivY = intersectionOffsetComparedToFrameCenter.x / intersectionOffsetComparedToFrameCenter.y;
            if (offsetXdivY > frameXdivY) { // case 4
                returnValue = EDGE_RIGHT;
            }
            else if (-offsetXdivY > frameXdivY) { // case 8
                returnValue = EDGE_LEFT;
            }
            else { // cases 5,6,7
                returnValue = EDGE_DOWN;                
            }
        }
        else if(intersectionOffsetComparedToFrameCenter.y < 0) { // cases 10,11,12,13,2
            float offsetXdivY = intersectionOffsetComparedToFrameCenter.x / intersectionOffsetComparedToFrameCenter.y;
            if (offsetXdivY > frameXdivY) { // case 10
                returnValue = EDGE_LEFT;
            }
            else if (-offsetXdivY > frameXdivY) { // case 2
                returnValue = EDGE_RIGHT;
            }
            else { // cases 11,12,13
                returnValue = EDGE_UP;                
            }
        }
        else { // cases 3,9
            if (intersectionOffsetComparedToFrameCenter.x > 0) { // case 3
                returnValue = EDGE_RIGHT;
            }
            else { // case 9
                returnValue = EDGE_LEFT;                
            }
        }
    }
    return returnValue;
}

@end
