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

const NSInteger MAX_RECORDING_DURATION_SECONDS = 180;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.jobNameTextField.delegate = self;
    self.recordingDurationTextField.delegate = self;
    [self.recordingDurationTextField setReturnKeyType:UIReturnKeyNext];
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
    if (![self isDurationTextValid]) {
        NSString *errorMessage = [NSString stringWithFormat:@"Please enter a duration between 1 and %d.", (int) MAX_RECORDING_DURATION_SECONDS];
        UIAlertView *durationError = [[UIAlertView alloc] initWithTitle:@"Invalid Duration" message:errorMessage delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
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
    NSLog(@"Recording did cancel.");
}

- (void)recordingDidFinish:(ARRecorderViewController *)sender withFileURL:(NSURL *)fileURL {
    // Need to do appropriate action when recording is finished successfully,
    // like uploading it.
    NSLog([NSString stringWithFormat:@"Recording did finish with file URL %@.", [fileURL absoluteString]]);
}

- (IBAction)unwindFromRecorderViewController:(UIStoryboardSegue *)segue {
    if ([segue.sourceViewController isKindOfClass:[ARRecorderViewController class]]) {
        NSLog([NSString stringWithFormat:@"Got back from recorder view controller. Segue ID: %@", segue.identifier]);
    }
}

@end
