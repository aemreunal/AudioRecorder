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
@property (strong, nonatomic) IBOutlet UILabel *durationCounter;

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
    self.recorder = [[ARRecorder alloc] initWithDuration:self.recordingDuration andName:self.recordingName];
    self.durationCounter.text = [NSString stringWithFormat:@"%i", self.recordingDuration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonTapped:(UIButton *)sender {
    [self.delegate recordingDidCancel:self];
}

@end
