//
//  QDNotificationWindow.m
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "QDNotificationWindow.h"
#import "QDNBViewController.h"

@implementation QDNotificationWindow

static dispatch_once_t onceToken;
static QDNotificationWindow *_instance = nil;

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"frame"];
    NSLog(@"dealloc:qd-%@", NSStringFromClass(self.class));
}

+ (instancetype)defaultWindow {
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] initWithFrame:CGRectZero];
        _instance.windowLevel = UIWindowLevelAlert;
        UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
        [_instance makeKeyAndVisible];
        [keyWindow makeKeyAndVisible];
        QDNBViewController *vc = [[QDNBViewController alloc] init];
        _instance.rootViewController = vc;
    });
    return _instance;
}

+ (void)deallocSingleton {
    onceToken = 0l;
    _instance = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }
    return self;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"frame"] && !CGRectEqualToRect(self.frame, CGRectZero)) {
        self.frame = CGRectZero;
    }
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    __block UIView *view;
    [self.rootViewController.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (CGRectContainsPoint(obj.frame, point)) {
            view = obj;
        }
    }];
    if (view) {
        CGPoint touchPoint = [self convertPoint:point toView:view];
        return [view hitTest:touchPoint withEvent:event];
    } else {
        return [super hitTest:point withEvent:event];
    }
}

@end
