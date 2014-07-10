//
//  ARFileNameHelper.m
//  AudioRecorder
//
//  Created by A. Emre Ünal on 07/07/14.
//  Copyright (c) 2014 A. Emre Ünal. All rights reserved.
//

#import "ARFileNameHelper.h"

@implementation ARFileNameHelper

+ (NSString *)getFileName:(NSString *)baseName {
    NSString *deviceModel = [self getDeviceModel];
    NSString *currentDate = [self getCurrentDateFormatted];
    NSString *fileName = [NSString stringWithFormat:@"%@-%@-%@", baseName, deviceModel, currentDate];
    return fileName;
}

+ (NSString *)getDeviceModel {
    return [self stringByRemovingWhitespace:[UIDevice currentDevice].model];
}

+ (NSString *)getCurrentDateFormatted {
    NSDate *today = [NSDate date];
    NSString *dateDescription = today.description;
    NSString *date = [dateDescription substringToIndex:10];
    NSString *time = [[[dateDescription substringFromIndex:11] substringToIndex:8] stringByReplacingOccurrencesOfString:@":" withString:@"-"];
    return [NSString stringWithFormat:@"%@-%@", date, time];
}

+ (NSString *)stringByRemovingWhitespace:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@"-"];
}

@end
