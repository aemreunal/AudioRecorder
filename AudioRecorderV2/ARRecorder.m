//
//  ARRecorder.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorder.h"

@interface ARRecorder ()

@property (strong, nonatomic) NSInteger *duration;
@property (strong, nonatomic) NSString *name;

@end

@implementation ARRecorder

- (instancetype)initWithDuration:(NSInteger *)duration andName:(NSString *)name {
    self = [super init];
    if (self) {
        
    }
    return self;
}

@end
