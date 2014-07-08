//
//  ARViewController.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARRecorderViewController.h"
#import "ARRecorderViewControllerDelegate.h"
#import "ARFileNameHelper.h"

const NSInteger MAX_RECORDING_DURATION_SECONDS = 180;

@interface ARViewController : UIViewController <ARRecorderViewControllerDelegate, UITextFieldDelegate>

@property(strong, nonatomic) IBOutlet UITextField *jobNameTextField;
@property(strong, nonatomic) IBOutlet UITextField *recordingDurationTextField;

- (IBAction)recordButtonTapped:(UIButton *)sender;

- (NSInteger)getRecordingDuration;

- (NSString *)getJobName;

@end
