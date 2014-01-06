//
//  AppDelegate.m
//  FitBit
//
//  Created by Karan MacbookPro on 1/3/14.
//  Copyright (c) 2014 KMG Infotech. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    UINavigationController *navController=(UINavigationController *)self.window.rootViewController;
    _controller=(ViewController *)[[navController viewControllers]objectAtIndex:0];
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    // naively parse url
    NSArray *urlComponents = [[url absoluteString] componentsSeparatedByString:@"?"];
    NSArray *requestParameterChunks = [[urlComponents objectAtIndex:1] componentsSeparatedByString:@"&"];
    for (NSString *chunk in requestParameterChunks) {
        NSArray *keyVal = [chunk componentsSeparatedByString:@"="];
        
        if ([[keyVal objectAtIndex:0] isEqualToString:@"oauth_verifier"]) {
           [_controller handleOAuthVerifier:[keyVal objectAtIndex:1]];
        }
        
    }
    
    return YES;
}
+(void)startProgressBar:(NSString *)strMessgae controller:(id)controller
{
    [controller view].userInteractionEnabled = NO;
    // UIInterfaceOrientation orientation=[[UIApplication sharedApplication] statusBarOrientation];
    UIView *alertView= [[UIView alloc] init];
  
        UIInterfaceOrientation orientation=[[UIApplication sharedApplication]statusBarOrientation];
    
    
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            
            alertView.frame = CGRectMake ( (480-145)/2 ,  (320-110)/2 , 145 , 110 );
            
        }
        else
            alertView.frame = CGRectMake ( (320-145)/2 ,  (480-110)/2 , 145 , 110 );

        
    }
    else{
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            
            alertView.frame = CGRectMake ( (924-145)/2 ,  (648-110)/2 , 145 , 110 );
            
        }
        else
            alertView.frame = CGRectMake ( (668-145)/2 ,  (924-110)/2 , 145 , 110 );
   
       }
    alertView. tag = 505 ;
    
    [alertView setBackgroundColor :[UIColor blackColor]];
    
    [alertView setAlpha : .7 ];
    
    alertView. layer . cornerRadius = 8.0f ;
    
    UILabel *lbl=[[ UILabel alloc ] initWithFrame : CGRectMake ( 0 , 50 , alertView. frame . size . width , 110 - 55 )];
    
    lbl. text =strMessgae;
    
    [lbl setBackgroundColor :[ UIColor clearColor ]];
    
    [lbl setTextColor :[ UIColor whiteColor ]];
    
    [lbl setFont :[ UIFont fontWithName : @"Helvetica-Bold" size : 18 ]];
    
    [lbl setTextAlignment : NSTextAlignmentCenter ];
    
    [alertView addSubview :lbl];
    
    UIActivityIndicatorView *activityIndicator = [[ UIActivityIndicatorView alloc ] initWithActivityIndicatorStyle : UIActivityIndicatorViewStyleWhiteLarge ];
    
    [activityIndicator setFrame : CGRectMake ( 45 , 10 , 55 , 55 )];
    
    [activityIndicator startAnimating ];
    
    [alertView addSubview :activityIndicator];
    
    [[controller view] addSubview :alertView];
    
}
+(void)changeActivityViewFrame:(id)controller
{
    UIView *activityView=[[controller view] viewWithTag:505];
   
        UIInterfaceOrientation orientation=[[UIApplication sharedApplication]statusBarOrientation];
        if (UIInterfaceOrientationIsLandscape(orientation)) {
            
            activityView.frame = CGRectMake ( (924-145)/2 ,  (648-110)/2 , 145 , 110 );
            
        }
        else
            activityView.frame = CGRectMake ( (668-145)/2 ,  (924-110)/2 , 145 , 110 );
    
    
}

+(void)StopProgressBar:(UIView *)view
{
    view.userInteractionEnabled = YES;
    
    UIView *rview=( UIView *)[view viewWithTag : 505 ];
    
    if (rview) {
        [rview removeFromSuperview ];
        
    }
    
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
