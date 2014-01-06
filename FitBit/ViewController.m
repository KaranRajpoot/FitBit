//
//  ViewController.m
//  FitBit
//
//  Created by Karan MacbookPro on 1/3/14.
//  Copyright (c) 2014 KMG Infotech. All rights reserved.
//

#import "ViewController.h"
#import "OAuthFitBit.h"
#import "OAuthConsumerCredentials.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
@interface ViewController ()<UIWebViewDelegate,OAuthFitBitCallbacks>
{
    NSOperationQueue *queue;
    UIWebView *webView;
    UIScrollView *scrollView;
}
@end

@implementation ViewController
@synthesize oAuthFitBit=_oAuthFitBit;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.navigationItem.title=@"FitBit";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
	queue = [[NSOperationQueue alloc] init];
	
     if ([OAUTH_CONSUMER_KEY isEqualToString:@""] || [OAUTH_CONSUMER_SECRET isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"FitBit Error" message:@"first set the fitbit consumer key and consumer secret" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
      
    }
    _oAuthFitBit = [[OAuthFitBit alloc] initWithConsumerKey:OAUTH_CONSUMER_KEY andConsumerSecret:OAUTH_CONSUMER_SECRET];
    _oAuthFitBit.delegate=self;

    [_oAuthFitBit load];
    // if user already autheried from fitbit api
    
    if (_oAuthFitBit.oauth_token_authorized)
    {
        UIBarButtonItem *loginBtn=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(fitbitLogout)];
        self.navigationItem.rightBarButtonItem=loginBtn;
        
        profileBtn.hidden=NO;
        activityBtn.hidden=NO;
        foodBtn.hidden=NO;
    }
    
    else{

        UIBarButtonItem *loginBtn=[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(fitbitLogin)];
        self.navigationItem.rightBarButtonItem=loginBtn;
    
    // Listen for keyboard hide/show notifications so we can properly reconfigure the UI
    
    }

}
-(void)fitbitLogin
{
    self.navigationItem.rightBarButtonItem=nil;
    [AppDelegate startProgressBar:@"Loading..." controller:self];
    [self requestTokenWithCallbackUrl:@"fitbit://handleOauthLogin"];
   
 
}
-(void)fitbitLogout
{
    [_oAuthFitBit forget];
    UIBarButtonItem *loginBtn=[[UIBarButtonItem alloc] initWithTitle:@"Login" style:UIBarButtonItemStylePlain target:self action:@selector(fitbitLogin)];
    self.navigationItem.rightBarButtonItem=loginBtn;
    
    profileBtn.hidden=YES;
    activityBtn.hidden=YES;
    foodBtn.hidden=YES;
}

- (void) requestTokenWithCallbackUrl:(NSString *)callbackUrl {
  //  [self.uiDelegate tokenRequestDidStart:self];
	
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:_oAuthFitBit
										selector:@selector(synchronousRequestFitBitTokenWithCallbackUrl:)
										object:callbackUrl];
	
	[queue addOperation:operation];
	//[operation release];
}
- (void)handleOAuthVerifier:(NSString *)oauth_verifier
{
    [self authorizeOAuthVerifier:oauth_verifier];
}
#pragma mark -
#pragma mark Authorize OAuth verifier received through URL callback or UI

- (void)authorizeOAuthVerifier:(NSString *)oauth_verifier {
    // delegate authorizationRequestDidStart
	//[self.uiDelegate authorizationRequestDidStart:self];
    
	NSInvocationOperation *operation = [[NSInvocationOperation alloc]
										initWithTarget:_oAuthFitBit
										selector:@selector(synchronousAuthorizeFitBitTokenWithVerifier:)
										object:oauth_verifier];
	[queue addOperation:operation];
    
}

#pragma mark -
#pragma mark OAuthFitBitCallbacks protocol

// For all of these methods, we invoked oAuth in a background thread, so these are also called
// in background thread. So we first transfer the control back to main thread before doing
// anything else.

- (void) requestFitBitTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestFitBitTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
    
    //	NSURL *myURL = [NSURL URLWithString:[NSString
    //										 stringWithFormat:@"https://api.twitter.com/oauth/authorize?oauth_token=%@",
    //										 _oAuth.oauth_token]];
    
    
    NSURL *myURL = [NSURL URLWithString:[NSString
										 stringWithFormat:@"https://www.fitbit.com/oauth/authorize?oauth_token=%@",
										 _oAuth.oauth_token]];
    
	
   
        
        // for callback flow, webview is initialized in XIB as the only child view, no need to init or push to navcontroller
        if (!webView) {
            CGRect appFrame = [UIScreen mainScreen].applicationFrame;
            
            webView = [[UIWebView alloc] initWithFrame:CGRectMake(0,0,appFrame.size.width,appFrame.size.height)];
            [webView setDelegate:self];
            webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [self.view addSubview:webView];
            webView.dataDetectorTypes = UIDataDetectorTypeNone;
            webView.scalesPageToFit = YES;
           // webView.delegate = self;
        }
        
      //  [[self navigationController] pushViewController:webViewController animated:YES];
    
        

    
	[webView loadRequest:[NSURLRequest requestWithURL:myURL]];
    
	//[self.uiDelegate tokenRequestDidSucceed:self];
    
}



- (void) requestFitBitTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(requestFitBitTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
  
    
	//[self.uiDelegate tokenRequestDidFail:self];
	
}

- (void) authorizeFitBitTokenDidSucceed:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeFitBitTokenDidSucceed:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
    [webView removeFromSuperview];
    
    NSLog(@"authorizationRequestDidSucceed");
    [_oAuthFitBit save];
    profileBtn.hidden=NO;
    activityBtn.hidden=NO;
    foodBtn.hidden=NO;
    
    UIBarButtonItem *loginBtn=[[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(fitbitLogout)];
    self.navigationItem.rightBarButtonItem=loginBtn;
    
	//[self.uiDelegate authorizationRequestDidSucceed:self];
    //[self.delegate oAuthLoginPopupDidAuthorize:self];
}

- (void) authorizeFitBitTokenDidFail:(OAuth *)_oAuth {
	if (![NSThread isMainThread]) {
		[self performSelectorOnMainThread:@selector(authorizeFitBitTokenDidFail:)
							   withObject:_oAuth
							waitUntilDone:NO];
		return;
	}
    
    NSLog(@"authorizationRequestDidFail");
	//[self.uiDelegate authorizationRequestDidFail:self];
}


#pragma mark -
#pragma mark Keyboard notifications

- (CGFloat)keyboardHeightFromNotification:(NSNotification *)aNotification {
    // http://stackoverflow.com/questions/2807339/uikeyboardboundsuserinfokey-is-deprecated-what-to-use-instead
    CGRect _keyboardEndFrame;
    [[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&_keyboardEndFrame];
    CGFloat _keyboardHeight;
    if (UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation])) {
        _keyboardHeight = _keyboardEndFrame.size.height;
    }
    else {
        _keyboardHeight = _keyboardEndFrame.size.width;
    }
    
    return _keyboardHeight;
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect scrollFrame = scrollView.frame;
    scrollFrame.size.height = self.view.frame.size.height - [self keyboardHeightFromNotification:aNotification];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    scrollView.frame = scrollFrame;
    [UIView commitAnimations];
    
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
    
    CGRect scrollFrame = scrollView.frame;
    scrollFrame.size.height = self.view.frame.size.height;
    
    NSTimeInterval animationDuration = [[[aNotification userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    scrollView.frame = scrollFrame;
    [UIView commitAnimations];
}
-(IBAction)getProfileDetail:(id)sender
{
    [self getDetail:getProfileInfo];
}
-(IBAction)getActivityDetail:(id)sender
{
    [self getDetail:getActivity];
}
-(IBAction)getFoodDetail:(id)sender
{
    [self getDetail:getFood];
}

-(void)getDetail:(NSString *)urlPath
{
    
    
    //NSString *str=@"http://api.fitbit.com/1/user/-/activities/date/2013-12-27.json";
    NSString *str=urlPath;
    NSString *oAuthValue = [_oAuthFitBit oAuthHeaderForMethod:@"GET" andUrl:str andParams:nil];

    NSURL *url = [NSURL URLWithString:str];
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
    [httpClient setParameterEncoding:AFJSONParameterEncoding];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [httpClient setDefaultHeader:@"Authorization" value:oAuthValue];
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET"
                                                            path:[url path]
                                                      parameters:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSError *err = nil;
        NSDictionary   *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&err];
        NSLog(@"%@ fitbit response=%@",urlPath,responseDict);
    }  failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
         NSLog(@"error messages getting %@",error);

     }];
    [operation start];

    /*
NSString *getUrl =@"http://api.fitbit.com/1/user/-/activities/date/2013-12-27.json";

//    NSDateFormatter *df=[[NSDateFormatter alloc] init];
//    [df setDateFormat:@"yyyy-MM-dd"];
//    NSString *date=[df stringFromDate:[NSDate date]];
//    NSString *getUrl =[NSString stringWithFormat:@"http://api.fitbit.com/1/user/-/activities/date/%@.json",date];


NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:@"5", @"count", nil];

// Note how the URL is without parameters here...
// (this is how OAuth works, you always give it a "normalized" URL without parameters
// since you give parameters separately to it, even for GET)
NSString *oAuthValue = [_oAuthFitBit oAuthHeaderForMethod:@"GET" andUrl:getUrl andParams:nil];

// ... but the actual request URL contains normal GET parameters.
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString
//                                                                                             stringWithFormat:@"%@?count=%@",
//                                                                                             getUrl,
//                                                                                             [params valueForKey:@"count"]]]];

NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString
                                                                                         stringWithFormat:@"%@",
                                                                                         getUrl
                                                                                         ]]];

[request addValue:oAuthValue forHTTPHeaderField:@"Authorization"];

NSHTTPURLResponse *response;
NSError *error = nil;

NSString *responseString = [[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error] encoding:NSUTF8StringEncoding];

NSLog(@"Got statuses. HTTP result code: %d", [response statusCode]);



    NSLog(@"%@",responseString);*/
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [AppDelegate StopProgressBar:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
