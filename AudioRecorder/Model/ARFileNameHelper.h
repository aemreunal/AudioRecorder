//
//  ARFileNameHelper.h
//  AudioRecorder
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ARFileNameHelper : NSObject

+ (NSString *)getFileName:(NSString *)baseName;

+ (NSString *)getDeviceModel;

+ (NSString *)getCurrentDateFormatted;

+ (NSString *)stringByRemovingWhitespace:(NSString *)string;

@end
