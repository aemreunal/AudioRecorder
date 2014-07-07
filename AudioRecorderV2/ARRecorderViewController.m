//
//  ARRecorderViewController.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARRecorderViewController.h"

@interface ARRecorderViewController ()

@property (strong, nonatomic) ARRecorder *recorder;
@property (strong, nonatomic) IBOutlet UIButton *recordButton;
@property (strong, nonatomic) IBOutlet UIButton *submitRecordingButton;
@property (strong, nonatomic) IBOutlet UILabel *durationCounter;
@property (strong, nonatomic) NSTimer* timer;

@end

@implementation ARRecorderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.recorder = [[ARRecorder alloc] initWithDuration:self.recordingDuration name:self.recordingName delegate:self];
    self.durationCounter.text = [NSString stringWithFormat:@"%i", self.recordingDuration];
    [self prepareForRecording];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
    if (!self.recorder.successfullyRecorded) {
        if ([self.recorder recording]) {
            // Have to cancel recording
            [self prepareForRecording];
            [self.recorder stopRecording];
        } else {
            // Have to start recording
            [self prepareForCancelling];
            [self.recorder startRecording];
        }
    } else {
        if ([self.recorder playing]) {
            // Can stop listening
            [self prepareForListeningAndSubmitting];
            [self.recorder stopPlaying];
        } else {
            // Can listen
            [self prepareForStopping];
            [self.recorder startPlaying];
        }
    }
}

- (IBAction)submitButtonTapped:(UIButton *)sender {
    [self.delegate recordingDidFinish:self withFileName:self.recorder.recordingFileName];
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self.recorder stopPlayingAndRecording];
    [self.delegate recordingDidCancel:self];
}

- (void)prepareForRecording {
    self.recordButton.titleLabel.text = @"Record";
    self.submitRecordingButton.enabled = NO;
    self.submitRecordingButton.hidden = YES;
}

- (void)prepareForCancelling {
    self.recordButton.titleLabel.text = @"Cancel";
    self.submitRecordingButton.enabled = NO;
    self.submitRecordingButton.hidden = YES;
}

- (void)prepareForStopping {
    self.recordButton.titleLabel.text = @"Stop";
    self.submitRecordingButton.enabled = YES;
    self.submitRecordingButton.hidden = NO;
}

-(void)prepareForListeningAndSubmitting {
    self.recordButton.titleLabel.text = @"Listen";
    self.durationCounter.text = @"0";
    self.submitRecordingButton.enabled = YES;
    self.submitRecordingButton.hidden = NO;
}

-(void)startDurationCounter {
    self.timer = [NSTimer timerWithTimeInterval:0.2f target:self selector:@selector(updateDurationCounter) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)stopDurationCounter {
    [self.timer invalidate];
    self.durationCounter.text = [NSString stringWithFormat:@"%i", self.recordingDuration];
}

-(void)updateDurationCounter {
    self.durationCounter.text = [NSString stringWithFormat:@"%i", [self.recorder timeLeft]];
}

@end
