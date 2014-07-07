//
//  ARRecorder.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ARRecorderDelegate.h"

@interface ARRecorder : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (strong, nonatomic) id <ARRecorderDelegate> delegate;

@property (nonatomic) NSInteger duration;
@property (strong, nonatomic) NSString *recordingFileName;
@property (nonatomic) BOOL successfullyRecorded;

- (instancetype)initWithDuration:(NSInteger)duration name:(NSString *)name delegate:(id<ARRecorderDelegate>)delegate;

- (void)startRecording;
- (void)stopRecording;
- (void)startPlaying;
- (void)stopPlaying;
- (void)stopPlayingAndRecording;
- (NSInteger)timeLeft;
- (BOOL)recording;
- (BOOL)playing;

@end
