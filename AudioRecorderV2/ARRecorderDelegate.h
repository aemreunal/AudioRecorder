//
//  ARRecorderDelegate.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ARRecorderDelegate <NSObject>

-(void)prepareForRecording;
-(void)prepareForListeningAndSubmitting;
-(void)startDurationCounter;
-(void)stopDurationCounter;
-(void)updateDurationCounter;

@end
