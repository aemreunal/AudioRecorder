//
//  ARRecorderViewController.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorderViewController.h"

@interface ARRecorderViewController ()

@property(strong, nonatomic) ARRecorder *recorder;
@property(strong, nonatomic) IBOutlet UIButton *recordButton;
@property(strong, nonatomic) IBOutlet UIButton *submitRecordingButton;
@property(strong, nonatomic) IBOutlet UILabel *durationCounter;
@property(strong, nonatomic) NSTimer *timer;

@end

@implementation ARRecorderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Pass
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[ARRecorder alloc] initWithDuration:self.recordingDuration name:self.recordingName delegate:self];
    [self switchToReadyToRecordState];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
//    [self stopDurationCounter];
//    self.timer = nil;
//    self.recorder = nil;
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
    if (!self.recorder.successfullyRecorded) {
        if ([self.recorder recording]) {
            // Have to cancel recording
            [self switchToReadyToRecordState];
        } else {
            // Have to start recording
            [self switchToRecordingState];
        }
    } else {
        if ([self.recorder playing]) {
            // Can stop listening
            [self switchToReadyToListenAndSubmitState];
        } else {
            // Can listen
            [self switchToListeningState];
        }
    }
}

- (void)switchToReadyToRecordState {
    [self.recorder stopRecording];
    [self stopDurationCounter];
    [self setButtonLabel:@"Record" submitButtonVisibility:NO];
    self.durationCounter.text = [NSString stringWithFormat:@"%i", self.recordingDuration];
}

- (void)switchToRecordingState {
    [self setButtonLabel:@"Cancel" submitButtonVisibility:NO];
    [self startDurationCounter];
    [self.recorder startRecording];
}

- (void)switchToReadyToListenAndSubmitState {
    [self.recorder stopPlaying];
    [self setButtonLabel:@"Listen" submitButtonVisibility:YES];
    self.durationCounter.text = @"0";
}

- (void)switchToListeningState {
    [self setButtonLabel:@"Stop" submitButtonVisibility:YES];
    [self.recorder startPlaying];
}

- (void)setButtonLabel:(NSString *)label submitButtonVisibility:(BOOL)visible {
    [self.recordButton setTitle:label forState:UIControlStateNormal];
    [self.submitRecordingButton setHidden:!visible];
}

- (void)startDurationCounter {
    self.timer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(updateDurationCounter) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)updateDurationCounter {
    NSInteger timeLeft = [self.recorder timeLeft];
    self.durationCounter.text = [NSString stringWithFormat:@"%i", timeLeft];
    if ([self.recorder timeLeft] <= 0) {
        self.recorder.successfullyRecorded = YES;
        [self stopDurationCounter];
        [self switchToReadyToListenAndSubmitState];
    }
}

- (void)stopDurationCounter {
    if(self.timer) {
        [self.timer invalidate];
    }
}

- (IBAction)submitButtonTapped:(UIButton *)sender {
    [self.recorder stopPlaying];
    if (self.recorder.successfullyRecorded) {
        [self.delegate recordingDidFinish:self withFileName:self.recorder.recordingFileName];
    }
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self.recorder stopPlayingAndRecording];
    [self.delegate recordingDidCancel:self];
}

@end
