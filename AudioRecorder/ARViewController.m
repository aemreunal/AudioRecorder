//
//  ARViewController.m
//  AudioRecorder
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobNameTextField.delegate = self;
    self.recordingDurationTextField.delegate = self;
    [self.recordingDurationTextField setReturnKeyType:UIReturnKeyNext];
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
    if (![self isDurationTextValid]) {
        UIAlertView *durationError = [[UIAlertView alloc] initWithTitle:@"Invalid Duration" message:@"Please enter a duration between 1 and 180." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [durationError show];
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return [self isDurationTextValid];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"RecorderViewModalSegue"]) {
        ARRecorderViewController *recorderViewController = (ARRecorderViewController *) segue.destinationViewController;
        recorderViewController.delegate = self;

        /*
        // To play a supplied audio file:
        recorderViewController.shouldOnlyPlay = YES;
        recorderViewController.recordingName = <<Recording file name with file extension>>;
        (Ex: recorderViewController.recordingName = @"job-iPhone-Simulator-2014-07-10-07-29-26.m4a";)
        */

        // To record an audio file:
        recorderViewController.shouldOnlyPlay = NO;
        recorderViewController.recordingName = [self getJobName]; // Without any file extension
        recorderViewController.recordingDuration = [self getRecordingDuration];
    }
}

- (NSInteger)getRecordingDuration {
    return [self.recordingDurationTextField.text integerValue];
}

- (NSString *)getJobName {
    NSString *jobName = [ARFileNameHelper stringByRemovingWhitespace:self.jobNameTextField.text];
    if ([jobName length] == 0) {
        jobName = @"job";
    }
    return [ARFileNameHelper getFileName:jobName];
}

- (BOOL)isDurationTextValid {
    NSInteger recordingDuration = [self getRecordingDuration];
    return (recordingDuration > 0 && recordingDuration <= MAX_RECORDING_DURATION_SECONDS);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    // If returning from duration text field, jump to job name text field
    if (textField == self.recordingDurationTextField) {
        [self.jobNameTextField becomeFirstResponder];
    }
    return YES;
}

- (void)recordingDidCancel:(ARRecorderViewController *)sender {
    // Need to do appropriate action when recording is cancelled.
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)recordingDidFinish:(ARRecorderViewController *)sender withFileURL:(NSURL *)fileURL {
    // Need to do appropriate action when recording is finished successfully,
    // like uploading it.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
