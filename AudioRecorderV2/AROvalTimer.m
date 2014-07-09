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

@property(nonatomic, strong) UIBezierPath *ovalPath;

@property(nonatomic) CGFloat halfSize;

@end

@implementation AROvalTimer

- (void)initTimerWithDuration:(CGFloat)duration {
    [self stopTimer];
    self.halfSize = [self frame].size.width / 2;
    oneMomentInAngle = MAX_ANGLE / (duration * FPS);
    self.ovalTimerStartAngle = OVAL_TIMER_END_ANGLE;
    self.timer = [NSTimer timerWithTimeInterval:(1 / FPS) target:self selector:@selector(tick) userInfo:nil repeats:YES];
}

- (void)drawRect:(CGRect)rect {
    [self clearDrawing];

    if (self.timer) {
        self.ovalPath = [UIBezierPath bezierPath];
        if (FILLED) {
            [self.ovalPath addArcWithCenter:CGPointMake(self.halfSize, self.halfSize) radius:self.halfSize startAngle:self.ovalTimerStartAngle * M_PI / 180 endAngle:OVAL_TIMER_END_ANGLE * M_PI / 180 clockwise:YES];
            [self.ovalPath addLineToPoint:CGPointMake(self.halfSize, self.halfSize)];
            [self.ovalPath closePath];

            [[UIColor whiteColor] setFill];
            [self.ovalPath fill];
        } else {
            [self.ovalPath addArcWithCenter:CGPointMake(self.halfSize, self.halfSize) radius:self.halfSize - STROKE_WIDTH startAngle:self.ovalTimerStartAngle * M_PI / 180 endAngle:OVAL_TIMER_END_ANGLE * M_PI / 180 clockwise:YES];

            [[UIColor whiteColor] setStroke];
            self.ovalPath.lineWidth = STROKE_WIDTH;
            [self.ovalPath stroke];
        }
    }
}

- (void)clearDrawing {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, self.bounds);
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
        [self setNeedsDisplay];
    }
}

- (void)tick {
    // Set elapsed time angle
    elapsedTimeInAngle += oneMomentInAngle;

    // Update oval angle
    self.ovalTimerStartAngle = (OVAL_TIMER_END_ANGLE + elapsedTimeInAngle);
    if (self.ovalTimerStartAngle > MAX_ANGLE) {
        self.ovalTimerStartAngle -= MAX_ANGLE;
    }
    if (elapsedTimeInAngle > MAX_ANGLE) {
        [self stopTimer];
    } else {
        [self setNeedsDisplay];
    }
}

@end
