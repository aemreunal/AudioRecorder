//
//  ARRecorder.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorder.h"

@interface ARRecorder () {
    AVAudioRecorder *recorder;
    AVAudioPlayer *player;
}

@end

@implementation ARRecorder

- (instancetype)initWithDuration:(NSInteger)duration name:(NSString *)name delegate:(id<ARRecorderDelegate>)delegate {
    self = [super init];
    if (self) {
        self.duration = duration;
        self.recordingFileName = [NSString stringWithFormat:@"%@.m4a", name];
        self.delegate = delegate;
        self.successfullyRecorded = NO;

        // Set the audio file
        NSArray *pathComponents = [NSArray arrayWithObjects: [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject], self.recordingFileName, nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];

        // Setup audio session
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];

        // Define the recorder setting
        NSMutableDictionary *recordSetting = [[NSMutableDictionary alloc] init];
        [recordSetting setValue:[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];

        // Initiate and prepare the recorder
        recorder = [[AVAudioRecorder alloc] initWithURL:outputFileURL settings:recordSetting error:NULL];
        recorder.delegate = self;
        recorder.meteringEnabled = YES;
        [recorder prepareToRecord];
    }
    return self;
}

- (void)startRecording {
    [self stopPlayingAndRecording];

    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];

    [recorder recordForDuration:self.duration];
}

- (void)stopRecording {
    if (recorder.recording) {
        [recorder stop];
        [recorder deleteRecording];

        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setActive:NO error:nil];
    }
}

- (void)startPlaying {
    [self stopPlayingAndRecording];

    player = [[AVAudioPlayer alloc] initWithContentsOfURL:recorder.url error:nil];
    [player setDelegate:self];
    [player play];
}

- (void)stopPlaying {
    if (player.playing) {
        [player stop];
    }
}

- (void)stopPlayingAndRecording {
    [self stopRecording];
    [self stopPlaying];
}

- (NSInteger)timeLeft {
    if (recorder) {
        return (NSInteger) (self.duration - [recorder currentTime] + 1);
    } else {
        return 0;
    }
}

- (BOOL)recording {
    return recorder.recording;
}

- (BOOL)playing {
    return player.playing;
}

- (void) audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag{
    if (flag) {
        [self.delegate stopDurationCounter];
        [self.delegate switchToReadyToListenAndSubmitState];
        self.successfullyRecorded = YES;
    }
}

- (void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: @"Done"
                                                    message: @"Finished playing the recording!"
                                                   delegate: nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

@end
