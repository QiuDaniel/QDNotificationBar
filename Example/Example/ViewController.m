//
//  ViewController.m
//  Example
//
//  Created by Daniel on 2018/7/12.
//  Copyright © 2018年 Daniel. All rights reserved.
//

#import "ViewController.h"
#import "CustomView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonPressed:(UIButton *)sender {
    CustomView *view = [[NSBundle mainBundle] loadNibNamed:@"CustomView" owner:nil options:nil].lastObject;
    CGSize size = UIScreen.mainScreen.bounds.size;
    QDNotificationBar *bar = [QDNotificationBar makeNotificationBarWithCustomView:view block:^(QDNBMaker *make) {
        make.barFrame = CGRectMake(0, 100, size.width, 94);
        make.soundId = 1312;
        make.stayDuration = 0;
        make.appearModel = QDNotificationBarAppearModelRight;
        make.animationDuration = 0.5;
    }];
    [bar show];
    view.bar = bar;
}

@end
