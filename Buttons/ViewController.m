//
//  ViewController.m
//  Buttons
//
//  Created by Sebastien Binet on 12-01-16.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"


#define UNKNOW_TIME 0.1

@interface ViewController()
@property (nonatomic) NSTimeInterval lastTimestamp;
@property (nonatomic) NSTimeInterval thisTimestamp;
@property (strong, nonatomic) NSTimer *mainTimer;
@property (nonatomic) NSTimeInterval deltaTime;
@property (nonatomic) float score;

-(void)calculateDeltaTime;
-(void)checkAndHandleCollisions;
-(void)updateObjectsPosition;
-(void)updateScore;

@end


@implementation ViewController
@synthesize Button1 = _Button1;
@synthesize Button0 = _Button0;
@synthesize Button2 = _Button2;
@synthesize Button3 = _Button3;
@synthesize Button4 = _Button4;
@synthesize Button5 = _Button5;
@synthesize Button6 = _Button6;
@synthesize Button7 = _Button7;
@synthesize Button8 = _Button8;
@synthesize Button9 = _Button9;
@synthesize Button10 = _Button10;
@synthesize Wall0 = _Wall0;
@synthesize Wall1 = _Wall1;
@synthesize Wall2 = _Wall2;
@synthesize Wall3 = _Wall3;
@synthesize Wall4 = _Wall4;
@synthesize Wall5 = _Wall5;
@synthesize Wall6 = _Wall6;
@synthesize Wall7 = _Wall7;
@synthesize CurrentScore = _CurrentScore;
@synthesize lastTimestamp = _lastTimestamp;
@synthesize thisTimestamp = _thisTimestamp;
@synthesize deltaTime = _deltaTime;
@synthesize score = _score;
@synthesize ObjectArray = _ObjectArray;
@synthesize mainTimer = _mainTimer;

/////////////////////
/////////////////////
/////////////////////
/////////////////////
/////////////////////
/////////////////////
/////////////////////
// NSArray makeObjectPerformSelector

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    // Create Array
    //self.ObjectArray = [NSArray arrayWithObjects:self.Button0, self.Button1, nil];
//    id tempId = self.Button0;
    int arraySize;
    id tempObj;
    
    IntelligentButton *tempButton0  = [[IntelligentButton alloc] initWithButton:self.Button0];
    IntelligentButton *tempButton1  = [[IntelligentButton alloc] initWithButton:self.Button1];
    IntelligentButton *tempButton2  = [[IntelligentButton alloc] initWithButton:self.Button2];
    IntelligentButton *tempButton3  = [[IntelligentButton alloc] initWithButton:self.Button3];
    IntelligentButton *tempButton4  = [[IntelligentButton alloc] initWithButton:self.Button4];
    IntelligentButton *tempButton5  = [[IntelligentButton alloc] initWithButton:self.Button5];
    IntelligentButton *tempButton6  = [[IntelligentButton alloc] initWithButton:self.Button6];
    IntelligentButton *tempButton7  = [[IntelligentButton alloc] initWithButton:self.Button7];
    IntelligentButton *tempButton8  = [[IntelligentButton alloc] initWithButton:self.Button8];
    IntelligentButton *tempButton9  = [[IntelligentButton alloc] initWithButton:self.Button9];
    IntelligentButton *tempButton10 = [[IntelligentButton alloc] initWithButton:self.Button10];
    IntelligentWall *tempWall0 = [[IntelligentWall alloc] initWithWallImageView:self.Wall0];
    IntelligentWall *tempWall1 = [[IntelligentWall alloc] initWithWallImageView:self.Wall1];
    IntelligentWall *tempWall2 = [[IntelligentWall alloc] initWithWallImageView:self.Wall2];
    IntelligentWall *tempWall3 = [[IntelligentWall alloc] initWithWallImageView:self.Wall3];
    IntelligentWall *tempWall4 = [[IntelligentWall alloc] initWithWallImageView:self.Wall4];
    IntelligentWall *tempWall5 = [[IntelligentWall alloc] initWithWallImageView:self.Wall5];
    IntelligentWall *tempWall6 = [[IntelligentWall alloc] initWithWallImageView:self.Wall6];
    IntelligentWall *tempWall7 = [[IntelligentWall alloc] initWithWallImageView:self.Wall7];

    NSLog(@"tempButton0 = %@", tempButton0);
    /*
    NSMutableArray *tempObjectArray = [NSArray arrayWithObjects:tempButton0, self.Button1, nil];
    arraySize = [tempObjectArray count];
    NSLog(@"Array size = %i", arraySize);
    tempObj = [tempObjectArray objectAtIndex:0];
    NSLog(@"Object at index 0 is = %i", [(UIButton*)tempObj tag]);
    */
        
    self.ObjectArray = [NSArray arrayWithObjects:
                        tempButton0, 
                        tempButton1, 
                        tempWall0, 
                        tempWall1, 
                        tempButton2, 
                        tempWall2, 
                        tempWall3, 
                        tempButton3, 
                        tempWall4, 
                        tempWall5, 
                        tempButton4, 
                        tempWall6, 
                        tempWall7, 
                        tempButton5, 
                        tempButton6, 
                        tempButton7, 
                        tempButton8, 
                        tempButton9, 
                        tempButton10, 
                        nil];
    arraySize = [self.ObjectArray count];
    NSLog(@"Array size = %i", arraySize);
    tempObj = [self.ObjectArray objectAtIndex:0];
    NSLog(@"Object at index 0 is = %@", tempObj);
    NSLog(@"Array = %@", self.ObjectArray);
    
    
    
    self.mainTimer = [NSTimer scheduledTimerWithTimeInterval:FRAME_REFRESH_PERIOD target:self selector:@selector(tick) userInfo:nil repeats:YES];
    self.lastTimestamp = [[NSDate date] timeIntervalSince1970];
    self.thisTimestamp = self.lastTimestamp;


}

- (void)viewDidUnload
{
    [self setButton0:nil];
    [self setButton1:nil];
    [self setCurrentScore:nil];
    [self setWall0:nil];
    [self setWall1:nil];
    [self setWall3:nil];
    [self setWall2:nil];
    [self setButton3:nil];
    [self setButton4:nil];
    [self setWall4:nil];
    [self setWall5:nil];
    [self setButton2:nil];
    [self setButton5:nil];
    [self setButton6:nil];
    [self setWall6:nil];
    [self setWall7:nil];
    [self setButton7:nil];
    [self setButton8:nil];
    [self setButton9:nil];
    [self setButton10:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES;
}

//////////////////////////////////////////////////////////////////////////////////////////////

- (IBAction)ButtonPressed:(UIButton *)sender {
    // Send the press information to every object in the array, and only the one that corresponds to that button will handle it
    
    //    ScreenObject* tempObj = [self.ObjectArray objectAtIndex:0];
    //    NSLog(@"Object at index 0 is = %@", tempObj);
    //    [tempObj checkAndHandleButtonPress:sender];
    //    [tempObj performSelector:@selector(checkAndHandleButtonPress:) withObject:sender];
    
    
    [self.ObjectArray makeObjectsPerformSelector:@selector(checkAndHandleButtonPress:) withObject:sender];
    
    
    
    
    //    
    //    ;
    //    id tempId = self.Button1;
    //    ;
    ////    [self.Button0 setTitle:@"3" forState:UIControlStateNormal]; 
    //    [self.Button1 setAlpha:0.3];
    ////    [sender setAlpha:0.3];
    //    
    //    NSInteger temp = [sender tag];
    //    NSLog(@"Button pressed = %i", temp);
    //     
    //    id tempObj = [self.ObjectArray objectAtIndex:0];
    //    NSLog(@"Object at index 0 is = %i", [(UIButton*)tempObj tag]);
}


-(void)calculateDeltaTime{
    self.lastTimestamp = self.thisTimestamp;
    self.thisTimestamp = [[NSDate date] timeIntervalSince1970];
    self.deltaTime = self.thisTimestamp - self.lastTimestamp;
    
    // Trick for debug
    if (self.deltaTime > 1.0) { // means that we stopped in the debugger for a while
        self.deltaTime = 0.1;
    }
}

-(void)checkAndHandleCollisions
{
    // compare every object of the array with the remaining objects in the array
    for (ScreenObject *obj0 in self.ObjectArray) {
        for (ScreenObject *obj1 in self.ObjectArray) {
            if ([self.ObjectArray indexOfObject:obj1] > [self.ObjectArray indexOfObject:obj0]) {
                [obj0 checkAndHandleCollisionWithObject:obj1];
            }
        }
    }
}

-(void)tick {
    [self calculateDeltaTime];
    [self updateObjectsPosition];
    [self checkAndHandleCollisions];

    [self updateScore];

}

-(void)updateObjectsPosition
{
    //ScreenObject *tempObj = [self.ObjectArray objectAtIndex:0];
    //[tempObj updatePositionWithDeltaTime:self.deltaTime];
    [self.ObjectArray makeObjectsPerformSelector:@selector(updatePositionWithDeltaTime:) withObject:[NSNumber numberWithDouble:self.deltaTime]];
    
}
-(void)updateScore
{
    for (ScreenObject *obj in self.ObjectArray) {
        self.score += [obj scoreImpact];
    }
    self.CurrentScore.progress=self.score / 100000 + 0.5;
}


@end
