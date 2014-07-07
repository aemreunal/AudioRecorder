//
//  RecordButton.m
//  AudioRecorder
//
//  Created by A. Emre Ünal on 03/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecordButton.h"

@interface ARRecordButton ()

@property (nonatomic) CGFloat recordButtonSize;

@end

@implementation ARRecordButton

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Color Declarations
    UIColor *color = [UIColor colorWithRed:1 green:0.114 blue:0.114 alpha:1];
    
    // Get screen bounds
    CGRect screenBounds = [self bounds];
    CGFloat screenWidth = screenBounds.size.width;
    CGFloat screenHeight = screenBounds.size.height;
    
    self.recordButtonSize = [self bounds].size.height;
    
    CGFloat xPos = (screenWidth - self.recordButtonSize) / 2;
    CGFloat yPos = (screenHeight - self.recordButtonSize) / 2;
    
    // Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(xPos, yPos, self.recordButtonSize, self.recordButtonSize)];
    [color setFill];
    [ovalPath fill];
}

@end
