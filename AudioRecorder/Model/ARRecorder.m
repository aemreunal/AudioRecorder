//
//  ARRecorder.m
//  AudioRecorder
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

- (instancetype)initAsRecorderWithName:(NSString *)name duration:(NSInteger)duration {
    self = [super init];
    if (self) {
        [self initAudioSessionWithFile:[NSString stringWithFormat:@"%@.m4a", name]];
        self.duration = duration;
        self.recordingDidFinish = NO;
        [self createRecorder];
    }
    return self;
}

- (instancetype)initAsPlayerForFile:(NSString *)name {
    self = [super init];
    if (self) {
        [self initAudioSessionWithFile:name];
        self.recordingDidFinish = YES;
        [self createPlayer];
    }
    return self;
}

- (void)initAudioSessionWithFile:(NSString *)fileName {
    NSArray *pathComponents = [NSArray arrayWithObjects:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], fileName, nil];
    self.recordingFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
}

- (void)createRecorder {
    self.recorder = [[AVAudioRecorder alloc] initWithURL:self.recordingFileURL settings:[self getRecorderSettings] error:NULL];
    self.recorder.delegate = self;
    self.recorder.meteringEnabled = YES;
    [self.recorder prepareToRecord];
}

- (void)createPlayer {
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:self.recordingFileURL error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
}

- (void)startRecording {
    [self stopPlayingAndRecording];
    if (!self.recorder) {
        [self createRecorder];
    }
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [self.recorder recordForDuration:self.duration];
}

- (void)stopRecording {
    if (self.recorder && self.recorder.recording) {
        [self.recorder stop];
        [self.recorder deleteRecording];
        [[AVAudioSession sharedInstance] setActive:NO error:nil];
    }
}

- (void)startPlaying {
    [self stopPlayingAndRecording];
    if (!self.player) {
        [self createPlayer];
    }
    [self.player play];
}

- (void)stopPlaying {
    if (self.player && self.player.playing) {
        [self.player stop];
        [self.player setCurrentTime:0];
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
    if (self.recorder) {
        return self.recorder.recording;
    } else {
        return NO;
    }
}

- (BOOL)playing {
    if (self.player) {
        return self.player.playing;
    } else {
        return NO;
    }
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
