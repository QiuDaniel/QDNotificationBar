//
//  QDMuteDetector.m
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "QDMuteDetector.h"
#import <AudioToolbox/AudioToolbox.h>
#import <UIKit/UIKit.h>

typedef void(^DetectCompleteBlock)(BOOL isMute);

@interface QDMuteDetector()

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) SystemSoundID soundId;
@property (nonatomic, copy) DetectCompleteBlock completeBlock;

@end

@implementation QDMuteDetector

static dispatch_once_t onceToken;
static QDMuteDetector *_instance = nil;

void QDSoundMuteNotificationCompletionProc(SystemSoundID ssId, void *clientData) {
    NSTimeInterval elapsed = [NSDate timeIntervalSinceReferenceDate] - [QDMuteDetector singletonDetector].interval;
    BOOL isMute = elapsed < 0.1;
    [QDMuteDetector singletonDetector].completeBlock(isMute);
}

- (void)dealloc {
    if (_soundId != -1) {
        AudioServicesRemoveSystemSoundCompletion(_soundId);
        AudioServicesDisposeSystemSoundID(_soundId);
    }
    NSLog(@"dealloc:qd-%@", NSStringFromClass(self.class));
}

+ (instancetype)singletonDetector {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"QDMuteDetector" withExtension:@"mp3"];
        if (AudioServicesCreateSystemSoundID((__bridge CFURLRef)url, &_instance->_soundId) == kAudioServicesNoError) {
            AudioServicesAddSystemSoundCompletion(_instance.soundId, CFRunLoopGetMain(), kCFRunLoopDefaultMode, QDSoundMuteNotificationCompletionProc, (__bridge void *)self);
            UInt32 yes = 1;
            AudioServicesSetProperty(kAudioServicesPropertyIsUISound, sizeof(_instance.soundId), &_instance->_soundId, sizeof(yes), &yes);
        } else {
            _instance.soundId = -1;
        }
    });
    return _instance;
}

+ (void)deallocSingleton {
    onceToken = 0l;
    _instance = nil;
}

- (void)detectCompletion:(void (^)(BOOL))completionHandler {
    self.interval = [NSDate timeIntervalSinceReferenceDate];
    AudioServicesPlaySystemSound(self.soundId);
    self.completeBlock = completionHandler;
}

@end
