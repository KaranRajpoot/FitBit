//
//  OAuthTwitter.h
//  PlainOAuth
//
//  Created by Jaanus Kase on 13.11.11.
//  Copyright (c) 2011 Intuit. All rights reserved.
//

#import "OAuth.h"
#import "OAuthFitBitCallbacks.h"

@interface OAuthFitBit : OAuth {

    NSString
    
    // From Twitter. May or may not be applicable to other providers.
    *user_id,
    *screen_name;
    
    //id<OAuthFitBitCallbacks> delegate;
}

@property (copy) NSString *user_id;
@property (copy) NSString *screen_name;
@property (assign) id<OAuthFitBitCallbacks> delegate;

// Twitter convenience methods
- (void) synchronousRequestFitBitToken;
- (void) synchronousRequestFitBitTokenWithCallbackUrl:(NSString *)callbackUrl;
- (void) synchronousAuthorizeFitBitTokenWithVerifier:(NSString *)oauth_verifier;
//- (BOOL) synchronousVerifyFitBitCredentials;
-(void)load;
-(void)save;
@end
