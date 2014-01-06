//
//  ViewController.h
//  FitBit
//
//  Created by Karan MacbookPro on 1/3/14.
//  Copyright (c) 2014 KMG Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OAuthFitBit.h"
#import "OAuthFitBitCallbacks.h"
#import "FitBitLoginUiFeedback.h"
@interface ViewController : UIViewController
{
    OAuthFitBit *oAuthFitBit;
    IBOutlet UIButton *profileBtn,*activityBtn,*foodBtn;
}
@property(nonatomic,retain)OAuthFitBit *oAuthFitBit;
- (void)handleOAuthVerifier:(NSString *)oauth_verifier;
-(IBAction)getProfileDetail:(id)sender;
-(IBAction)getActivityDetail:(id)sender;
-(IBAction)getFoodDetail:(id)sender;
@end
