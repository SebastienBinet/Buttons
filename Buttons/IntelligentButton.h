//
//  IntelligentButton.h
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScreenObject.h"
#import <UIKit/UIKit.h>
typedef enum  {
  BUTTON_STATE_UP = 0,
  BUTTON_STATE_DOWN = 1
} ButtonState;

@interface IntelligentButton : ScreenObject

-(id)initWithButton:(UIButton *)button;

//+(void)
@end
