//
//  ARRecorder.h
//  AudioRecorder
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "ARRecorderDelegate.h"

@interface ARRecorder : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property(strong, nonatomic) id <ARRecorderDelegate> delegate;

@property(nonatomic) NSInteger duration;
@property(strong, nonatomic) NSURL *recordingFileURL;
@property(nonatomic) BOOL recordingDidFinish;

- (instancetype)initAsRecorderWithName:(NSString *)name duration:(NSInteger)duration;

- (instancetype)initAsPlayerForFile:(NSString *)name;

- (void)startRecording;

- (void)stopRecording;

- (void)startPlaying;

- (void)stopPlaying;

- (void)stopPlayingAndRecording;

- (NSInteger)timeLeft;

- (BOOL)recording;

- (BOOL)playing;

@end
