//
//  ARRecorderViewController.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARRecorderViewControllerDelegate.h"
#import "ARRecorderDelegate.h"
#import "ARRecorder.h"
#import "AROvalTimer.h"


@interface ARRecorderViewController : UIViewController <ARRecorderDelegate>

@property(strong, nonatomic) id <ARRecorderViewControllerDelegate> delegate;

@property(nonatomic) NSInteger recordingDuration;
@property(strong, nonatomic) NSString *recordingName;

- (IBAction)recordButtonTapped:(UIButton *)sender;

- (IBAction)submitButtonTapped:(UIButton *)sender;

- (IBAction)cancelButtonTapped:(UIButton *)sender;

@end
