//
//  AROvalTimer.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 08/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "AROvalTimer.h"

@interface AROvalTimer () {
    CGFloat oneMomentInAngle;
    CGFloat elapsedTimeInAngle;
}

@property(nonatomic) CGFloat ovalTimerStartAngle;

@property(nonatomic, strong) NSTimer *timer;

@end

@implementation AROvalTimer

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        elapsedTimeInAngle = 0;
        self.ovalTimerStartAngle = OVAL_TIMER_END_ANGLE;
    }
    return self;
}

- (void)initTimerWithDuration:(CGFloat)duration {
    [self stopTimer];
    oneMomentInAngle = MAX_ANGLE / (duration * FPS);
    elapsedTimeInAngle = 0;
    self.ovalTimerStartAngle = OVAL_TIMER_END_ANGLE;
    self.timer = [NSTimer timerWithTimeInterval:(1 / FPS) target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)drawRect:(CGRect)rect {
//    dispatch_async(dispatch_get_main_queue(), ^{
    UIBezierPath *ovalTimerPath = [UIBezierPath bezierPath];
    [ovalTimerPath addArcWithCenter:CGPointMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame])) radius:CGRectGetWidth([self frame]) / 2 startAngle:self.ovalTimerStartAngle * M_PI / 180 endAngle:OVAL_TIMER_END_ANGLE * M_PI / 180 clockwise:YES];
    [ovalTimerPath addLineToPoint:CGPointMake(CGRectGetMidX([self frame]), CGRectGetMidY([self frame]))];
    [ovalTimerPath closePath];

    [[UIColor whiteColor] setFill];
    [ovalTimerPath fill];
    CGRect frame = [self frame];
    NSLog(@"Draw rect x:%f, y:%f, w:%f, h:%f, startAngle:%f", frame.origin.x, frame.origin.y, frame.size.width, frame.size.height, self.ovalTimerStartAngle);
//    });
}

- (void)startTimer {
    if (self.timer) {
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer {
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)tick {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Set elapsed time angle
        elapsedTimeInAngle += oneMomentInAngle;


        // Update oval angle
        self.ovalTimerStartAngle = (OVAL_TIMER_END_ANGLE + elapsedTimeInAngle);
        if (self.ovalTimerStartAngle > MAX_ANGLE) {
            self.ovalTimerStartAngle -= MAX_ANGLE;
        }
        [self setNeedsDisplay];
    });
}

@end
