//
//  Helpers.m
//  Buttons
//
//  Created by Sebastien Binet on 12-01-17.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Helpers.h"

float randFloat(float min, float max)
{
    const int MASK = 0xFFFF;
    int tempInt = rand();
    float tempFloat = ((tempInt & MASK)/(MASK + 0.0f)); // 0.0 to 1.0
    float size = max - min;
    float returnValue = (tempFloat * size) + min;
    return returnValue;
}

@implementation Helpers

@end
