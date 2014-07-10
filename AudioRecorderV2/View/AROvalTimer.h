//
//  AROvalTimer.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 08/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat MAX_ANGLE = 360.0f;
static const CGFloat OVAL_TIMER_END_ANGLE = 270.0f; // EndAngle is reached at the end of the timer.
static const CGFloat FPS = 60; // The frequency of update of the oval timer
static const int STROKE_WIDTH = 11;

@interface AROvalTimer : UIView

- (void)initTimerWithDuration:(CGFloat)duration;

- (void)startTimer;

- (void)stopTimer;

@end
