//
//  AppDelegate.h
//  FitBit
//
//  Created by Karan MacbookPro on 1/3/14.
//  Copyright (c) 2014 KMG Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,retain)ViewController *controller;
+(void)startProgressBar:(NSString *)strMessgae controller:(id)controller;
+(void)StopProgressBar:(UIView *)view;
+(void)changeActivityViewFrame:(id)controller;
@end
