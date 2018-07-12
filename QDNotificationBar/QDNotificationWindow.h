//
//  QDNotificationWindow.h
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface QDNotificationWindow : UIWindow

+ (instancetype)defaultWindow;
+ (void)deallocSingleton;

@end


