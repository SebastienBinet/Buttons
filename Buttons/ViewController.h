//
//  ViewController.h
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScreenObject.h"
#import "IntelligentButton.h"
#import "IntelligentWall.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *Button1;
@property (weak, nonatomic) IBOutlet UIButton *Button0;
@property (weak, nonatomic) IBOutlet UIButton *Button2;
@property (weak, nonatomic) IBOutlet UIButton *Button3;
@property (weak, nonatomic) IBOutlet UIButton *Button4;
@property (weak, nonatomic) IBOutlet UIButton *Button5;
@property (weak, nonatomic) IBOutlet UIButton *Button6;
@property (weak, nonatomic) IBOutlet UIButton *Button7;
@property (weak, nonatomic) IBOutlet UIButton *Button8;
@property (weak, nonatomic) IBOutlet UIButton *Button9;
@property (weak, nonatomic) IBOutlet UIButton *Button10;
@property (weak, nonatomic) IBOutlet UIImageView *Wall0;
@property (weak, nonatomic) IBOutlet UIImageView *Wall1;
@property (weak, nonatomic) IBOutlet UIImageView *Wall2;
@property (weak, nonatomic) IBOutlet UIImageView *Wall3;
@property (weak, nonatomic) IBOutlet UIImageView *Wall4;
@property (weak, nonatomic) IBOutlet UIImageView *Wall5;
@property (weak, nonatomic) IBOutlet UIImageView *Wall6;
@property (weak, nonatomic) IBOutlet UIImageView *Wall7;
@property (weak, nonatomic) IBOutlet UIProgressView *CurrentScore;
@property (strong, nonatomic) IBOutletCollection(ScreenObject) NSArray *ObjectArray;


@end
