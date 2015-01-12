//
//  ViewController.h
//  xiche
//
//  Created by Apple on 14-12-3.
//  Copyright (c) 2014年 Apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextView *ib_tview;

- (IBAction)btNearCar:(id)sender;//附近的车
- (IBAction)btChat:(id)sender;//聊天


@end

