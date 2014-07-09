//
//  ARRecorder.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorder.h"

@interface ARRecorder ()

@property(nonatomic, strong) AVAudioRecorder *recorder;
@property(nonatomic, strong) AVAudioPlayer *player;

@end

@implementation ARRecorder

- (instancetype)initWithDuration:(NSInteger)duration name:(NSString *)name delegate:(id <ARRecorderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.duration = duration;
        self.recordingFileName = [NSString stringWithFormat:@"%@.m4a", name];
        self.delegate = delegate;
        self.successfullyRecorded = NO;

        [self setAudioSession];
        [self setRecorder];
    }
    return self;
}

- (void)setAudioSession {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

- (void)setRecorder {
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], self.recordingFileName, nil];
    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

    self.recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:[self getRecorderSettings] error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)startRecording {
    [self stopPlayingAndRecording];

    [[AVAudioSession sharedInstance] setActive:YES error:nil];

    [self.recorder recordForDuration:self.duration];
}

- (void)stopRecording {
    if (self.recorder.recording) {
        [self.recorder stop];
        [self.recorder deleteRecording];

        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

- (void)startPlaying {
    [self stopPlayingAndRecording];

    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recorder.url error:nil];
    [self.player setDelegate:self];
    [self.player play];
}

- (void)stopPlaying {
    if (self.player.playing) {
        [self.player stop];
    }
}

- (void)stopPlayingAndRecording {
    [self stopRecording];
    [self stopPlaying];
}

- (NSInteger)timeLeft {
    if (self.recorder) {
        return (NSInteger) (self.duration - [self.recorder currentTime] + 1);
    } else {
        return 0;
    }
}

- (BOOL)recording {
    return self.recorder.recording;
}

- (BOOL)playing {
    return self.player.playing;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self.delegate switchToReadyToListenAndSubmitState];
}

- (NSMutableDictionary *)getRecorderSettings {
    NSMutableDictionary *recordSettings = [[NSMutableDictionary alloc] init];
    [recordSettings setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
    [recordSettings setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
    [recordSettings setValue:[NSNumber numberWithInt:2] forKey:AVNumberOfChannelsKey];
    return recordSettings;
}

@end
