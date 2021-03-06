//
//  AFGitHubAppDelegate.m
//
//  Copyright (c) 2012 Atsushi Nagase (http://ngs.io/)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#import "AFGitHubSampleAppDelegate.h"

#import "AFNetworkActivityIndicatorManager.h"
#import "AFGitHubAPIKeys.h"
#import "AFGitHub.h"
#import "AFGitHubGlobal.h"
#import "AFGitHubSampleConstants.h"

@implementation AFGitHubSampleAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSURLCache *URLCache = [[NSURLCache alloc]
                          initWithMemoryCapacity:8 * 1024 * 1024
                          diskCapacity:20 * 1024 * 1024
                          diskPath:nil];
  [NSURLCache setSharedURLCache:URLCache];
  [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
  AFGitHubAPIClient *client = [AFGitHubAPIClient clientWithClientID:kAFGitHubClientID secret:kAFGitHubClientSecret];
  NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:AFGitHubDefaultsAccessTokenKey];
  if(AFGitHubIsStringWithAnyText(accessToken))
    [client setAuthorizationHeaderWithToken:accessToken];
  [AFGitHubAPIClient setSharedClient:client];
  NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
  [nc addObserver:self selector:@selector(didLogin:) name:AFGitHubNotificationAuthenticationSuccess object:nil];
  [nc addObserver:self selector:@selector(didLogout:) name:AFGitHubNotificationAuthenticationCleared object:nil];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
  [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Notification Observer

- (void)didLogin:(NSNotification *)note {
  AFOAuthCredential *credential = note.userInfo[@"credential"];
  [[NSUserDefaults standardUserDefaults] setObject:credential.accessToken forKey:AFGitHubDefaultsAccessTokenKey];
}

- (void)didLogout:(NSNotification *)note {
  [[NSUserDefaults standardUserDefaults] removeObjectForKey:AFGitHubDefaultsAccessTokenKey];
}

@end
