//
//  ARRecorderViewControllerDelegate.h
//  AudioRecorderV2
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ARRecorderViewController.h"

@class ARRecorderViewController;

@protocol ARRecorderViewControllerDelegate <NSObject>

- (void)recordingDidCancel:(ARRecorderViewController *)sender;

- (void)recordingDidFinish:(ARRecorderViewController *)sender withFileURL:(NSURL *)fileURL;

@end
