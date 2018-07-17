//
//  QDNotificationBar.h
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/12.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QDNotificationBarAppearMode) {
    QDNotificationBarAppearModeTop = 0,
    QDNotificationBarAppearModeLeft,
    QDNotificationBarAppearModeRight
};

@class QDNBMaker;

@interface QDNotificationBar : NSObject

+ (instancetype)makeNotificationBarWithCustomView:(UIView *)view block:(void(^)(QDNBMaker *make))block;

- (void)show;
- (void)hide;

@end

@interface QDNBMaker : NSObject

@property (nonatomic, assign) CGRect barFrame;
@property (nonatomic, assign) NSTimeInterval animationDuration;
@property (nonatomic, assign) NSTimeInterval stayDuration;
@property (nonatomic, assign) UInt32 soundId;
@property (nonatomic, copy) NSString *soundName;
@property (nonatomic, assign) QDNotificationBarAppearMode appearModel;

@end

