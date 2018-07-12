//
//  QDMuteDetector.h
//  QDNotificationBar
//
//  Created by Daniel on 2018/7/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QDMuteDetector : NSObject

+ (instancetype)singletonDetector;
+ (void)deallocSingleton;

- (void)detectCompletion:(void(^)(BOOL isMute))completionHandler;

@end


