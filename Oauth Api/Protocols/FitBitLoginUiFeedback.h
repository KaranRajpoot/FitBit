/*
 *  TwitterLoginUiFeedback.h
 *  Special People
 *
 *  Created by Jaanus Kase on 19.04.10.
 *  Copyright 2010 __MyCompanyName__. All rights reserved.
 *
 */

@class FitBitLoginPopup;
@protocol FitBitLoginUiFeedback <NSObject>
- (void) tokenRequestDidStart:(FitBitLoginPopup *)fitbitLogin;
- (void) tokenRequestDidSucceed:(FitBitLoginPopup *)fitbitLogin;
- (void) tokenRequestDidFail:(FitBitLoginPopup *)fitbitLogin;

- (void) authorizationRequestDidStart:(FitBitLoginPopup *)fitbitLogin;
- (void) authorizationRequestDidSucceed:(FitBitLoginPopup *)fitbitLogin;
- (void) authorizationRequestDidFail:(FitBitLoginPopup *)fitbitLogin;

@end
