//
//  QDNotificationBar.m
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/12.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "QDNotificationBar.h"
#import "QDNotificationWindow.h"
#import <AudioToolbox/AudioToolbox.h>
#import "QDMuteDetector.h"

@interface QDNBMaker ()

@property (nonatomic, weak) UIView *customView;

@end

@implementation QDNBMaker

+ (instancetype)makerWithCustomView:(UIView *)view {
    QDNBMaker *maker = [[QDNBMaker alloc] init];
    maker.animationDuration = 0.3;
    maker.stayDuration = 4.0;
    maker.soundId = 0;
    maker.customView = view;
    maker.barFrame = view.frame;
    maker.appearMode = QDNotificationBarAppearModeTop;
    return maker;
}

@end

@interface QDNotificationBar ()

@property (nonatomic, strong) QDNBMaker *maker;

@end

static NSMutableArray<QDNotificationBar *> *bars;
static QDNotificationWindow *singletonWindow;
static dispatch_once_t onceToken;

@implementation QDNotificationBar

- (void)dealloc {
    NSLog(@"dealloc:qd-%@", NSStringFromClass(self.class));
}

// MARK: - Public

+ (instancetype)makeNotificationBarWithCustomView:(UIView *)view block:(void (^)(QDNBMaker *))block {
    [QDNotificationBar singletonInitBar];
    QDNotificationBar *bar = [[QDNotificationBar alloc] init];
    QDNBMaker *maker = [QDNBMaker makerWithCustomView:view];
    bar.maker = maker;
    block(maker);
    return bar;
}

- (void)show {
    [bars addObject:self];
    if (self.maker.soundName || self.maker.soundId != 0) {
        SystemSoundID soundID;
        if (self.maker.soundName) {
            NSURL *url = [[NSBundle mainBundle] URLForResource:self.maker.soundName withExtension:nil];
            AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        } else {
            soundID = self.maker.soundId;
        }
        [[QDMuteDetector singletonDetector] detectCompletion:^(BOOL isMute) {
            AudioServicesPlaySystemSound(isMute ? kSystemSoundID_Vibrate: soundID);
        }];
    }
    [singletonWindow.rootViewController.view addSubview:self.maker.customView];
    self.maker.customView.frame = [self hideFrame];
    [UIView animateWithDuration:self.maker.animationDuration animations:^{
        self.maker.customView.frame = [self showFrame];
    } completion:^(BOOL finished) {
        if (self.maker.stayDuration > 0) {
            [self performSelector:@selector(hide) withObject:nil afterDelay:self.maker.stayDuration];
        }
    }];
}

- (void)hide {
    if (!self.maker.customView.superview) {
        return;
    }
    [UIView animateWithDuration:self.maker.animationDuration animations:^{
        self.maker.customView.frame = [self hideFrame];
    } completion:^(BOOL finished) {
        if (self.maker.customView.superview) {
            [self.maker.customView removeFromSuperview];
        }
        if ([bars containsObject:self]) {
            [bars removeObject:self];
        }
        if (bars.count == 0) {
            [self destorySingleton];
            [QDNotificationWindow deallocSingleton];
            [QDMuteDetector deallocSingleton];
        }
    }];
    
}

// MARK: - Private

- (CGRect)showFrame {
    return self.maker.barFrame;
}

- (CGRect)hideFrame {
    CGRect frame = [self showFrame];
    switch (self.maker.appearMode) {
        case QDNotificationBarAppearModeTop:
            frame.origin.y = -frame.size.height;
            break;
        case QDNotificationBarAppearModeLeft:
            frame.origin.x = -frame.size.width;
            break;
        case QDNotificationBarAppearModeRight:
            frame.origin.x = [UIScreen mainScreen].bounds.size.width + frame.size.width;
            break;
        default:
            break;
    }
    
    return frame;
}

+ (void)singletonInitBar {
    dispatch_once(&onceToken, ^{
        bars = [NSMutableArray array];
        singletonWindow = [QDNotificationWindow defaultWindow];
    });
}

- (void)destorySingleton {
    onceToken = 0l;
    singletonWindow = nil;
    bars = nil;
}

@end
