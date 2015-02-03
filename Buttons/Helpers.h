//
//  Helpers.h
//  Buttons
//
//  Created by Sebastien Binet on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


#define FRAME_REFRESH_PERIOD 0.01

typedef enum {
    EDGE_DOWN  = 0,
    EDGE_LEFT  = 1,
    EDGE_RIGHT = 2,
    EDGE_UP    = 3
} Edge;

float randFloat(float min, float max);

@interface Helpers : NSObject

@end
