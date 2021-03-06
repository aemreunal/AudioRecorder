//
//  ARRecorderViewController.m
//  AudioRecorder
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorderViewController.h"

@interface ARRecorderViewController ()

@property(strong, nonatomic) ARRecorder *recorder;
@property(strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *submitButton;
@property(strong, nonatomic) IBOutlet UILabel *durationCounter;
@property(strong, nonatomic) IBOutlet AROvalTimer *ovalTimer;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation ARRecorderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRecorder];
}

- (void)viewDidAppear:(BOOL)animated {
    if (!self.recorder) {
        [self initRecorder];
    }
}

- (void)initRecorder {
    self.recorder = [ARRecorder alloc];
    if(!self.shouldOnlyPlay) {
        self.recorder = [self.recorder initAsRecorderWithName:self.recordingName duration:(long) self.recordingDuration];
        [self switchToReadyToRecordState];
    } else {
        self.recorder = [self.recorder initAsPlayerForFile:self.recordingName];
        [self switchToReadyToListenAndSubmitState];
    }
    self.recorder.delegate = self;
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
    if (!self.recorder.recordingDidFinish) {
        [self toggleRecorderState];
    } else {
        [self togglePlayerState];
    }
}

- (void)toggleRecorderState {
    if (![self.recorder recording]) {
        // Have to start recording
        [self switchToRecordingState];
    } else {
        // Have to cancel recording
        [self switchToReadyToRecordState];
    }
}

- (void)togglePlayerState {
    if (![self.recorder playing]) {
        // Can listen
        [self switchToListeningState];
    } else {
        // Can stop listening
        [self switchToReadyToListenAndSubmitState];
    }
}

- (void)switchToReadyToRecordState {
    [self.recorder stopRecording];
    [self stopDurationCounter];
    [self.ovalTimer initTimerWithDuration:(CGFloat) self.recordingDuration];
    [self setButtonLabel:@"Record" submitButtonVisibility:NO];
    self.durationCounter.text = [NSString stringWithFormat:@"%li", (long) self.recordingDuration];
}

- (void)switchToRecordingState {
    [self setButtonLabel:@"Cancel" submitButtonVisibility:NO];
    [self startDurationCounter];
    [self.ovalTimer startTimer];
    [self.recorder startRecording];
}

- (void)switchToReadyToListenAndSubmitState {
    [self.recorder stopPlaying];
    [self.ovalTimer initTimerWithDuration:(CGFloat) self.recordingDuration];
    [self setButtonLabel:@"Listen" submitButtonVisibility:YES];
    self.durationCounter.text = @"0";
}

- (void)switchToListeningState {
    [self setButtonLabel:@"Stop" submitButtonVisibility:YES];
    [self.recorder startPlaying];
}

- (void)setButtonLabel:(NSString *)label submitButtonVisibility:(BOOL)visible {
    [self.recordButton setTitle:label forState:UIControlStateNormal];
    [self.submitButton setEnabled:visible];
}

- (void)startDurationCounter {
    self.timer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(updateDurationCounter) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateDurationCounter {
    self.durationCounter.text = [NSString stringWithFormat:@"%li", (long) [self.recorder timeLeft]];
    if ([self.recorder timeLeft] <= 0) {
        self.recorder.recordingDidFinish = YES;
        [self stopDurationCounter];
        [self.ovalTimer stopTimer];
        [self switchToReadyToListenAndSubmitState];
    }
}

- (void)stopDurationCounter {
    if (self.timer) {
        [self.timer invalidate];
    }
}

- (IBAction)submitButtonTapped:(UIButton *)sender {
    [self.recorder stopPlaying];
    if (self.recorder.recordingDidFinish) {
        [self.delegate recordingDidFinish:self withFileURL:self.recorder.recordingFileURL];
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self.recorder stopPlayingAndRecording];
    [self.delegate recordingDidCancel:self];
}

@end
