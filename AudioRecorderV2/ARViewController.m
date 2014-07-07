//
//  ARViewController.m
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARViewController.h"

@interface ARViewController ()

@end

@implementation ARViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jobNameTextField.delegate = self;
    self.recordingDurationTextField.delegate = self;
    [self.recordingDurationTextField setReturnKeyType:UIReturnKeyNext];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)recordButtonTapped:(UIButton *)sender {
//    [self performSegueWithIdentifier:@"RecorderViewModalSegue" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"RecorderViewModalSegue"]) {
        ARRecorderViewController *recorderViewController = (ARRecorderViewController *) segue.destinationViewController;
        recorderViewController.delegate = self;
        recorderViewController.recordingDuration = [self getRecordingDuration];
        recorderViewController.recordingName = [self getJobName];
    }
}

- (NSInteger)getRecordingDuration {
    NSInteger recordingDuration = [self.recordingDurationTextField.text integerValue];
    if (recordingDuration) {
        return recordingDuration;
    } else {
        return DEFAULT_RECORDING_DURATION_SECONDS;
    }
    return [self.recordingDurationTextField.text integerValue];
}

-(NSString *)getJobName {
    NSString *jobName = [ARFileNameHelper stringByRemovingWhitespace:self.jobNameTextField.text];
    if ([jobName length] == 0) {
        jobName = @"job";
    }
    return [ARFileNameHelper getFileName:jobName];
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

- (void)recordingDidFinish:(ARRecorderViewController *)sender withFileName:(NSString *)fileName {
    // Need to do appropriate action when recording is finished successfully,
    // like uploading it.
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
