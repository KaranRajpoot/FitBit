/*
 *  OAuthTwitterCallbacks.h
 *  Special People
 *
 *  Created by Jaanus Kase on 19.04.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@class OAuth;

@protocol OAuthFitBitCallbacks<NSObject>
- (void) requestFitBitTokenDidSucceed:(OAuth *)oAuth;
- (void) requestFitBitTokenDidFail:(OAuth *)oAuth;
- (void) authorizeFitBitTokenDidSucceed:(OAuth *)oAuth;
- (void) authorizeFitBitTokenDidFail:(OAuth *)oAuth;
@end

