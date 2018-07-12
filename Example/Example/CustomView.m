//
//  CustomView.m
//  Example
//
//  Created by Daniel on 2018/7/11.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "CustomView.h"

@interface CustomView()

@end

@implementation CustomView

- (IBAction)closeAction:(UIButton *)sender {
    [self.bar hide];
}


- (IBAction)touchAction:(UIButton *)sender {
    NSLog(@"跳转");
}


@end
