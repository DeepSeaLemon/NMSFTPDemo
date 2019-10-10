//
//  SearchViewController.m
//  NewTest
//
//  Created by 10361 on 2019/10/10.
//  Copyright © 2019 10361. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()<NSNetServiceBrowserDelegate>

@property (nonatomic, strong) NSNetServiceBrowser *browser;
@property (nonatomic, assign, readwrite, getter=isSearching) BOOL searching;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self startSearchSftpServices];
}

- (void)startSearchSftpServices {
    if (self.searching) {
        [self stopSearch];
    }
    [self.browser scheduleInRunLoop:NSRunLoop.mainRunLoop forMode:NSRunLoopCommonModes];
    [self.browser searchForServicesOfType:@"_smb._tcp." inDomain:@"local."];
}

- (void)stopSearch {
    [self.browser stop];
}

#pragma mark - NSNetServiceBrowserDelegate

/* Sent to the NSNetServiceBrowser instance's delegate before the instance begins a search. The delegate will not receive this message if the instance is unable to begin a search. Instead, the delegate will receive the -netServiceBrowser:didNotSearch: message.
 */
- (void)netServiceBrowserWillSearch:(NSNetServiceBrowser *)browser {
    NSLog(@"netServiceBrowserWillSearch");
    self.searching = YES;
}

/* Sent to the NSNetServiceBrowser instance's delegate when the instance's previous running search request has stopped.
 */
- (void)netServiceBrowserDidStopSearch:(NSNetServiceBrowser *)browser {
    NSLog(@"netServiceBrowserDidStopSearch");
    self.searching = NO;
}

/* Sent to the NSNetServiceBrowser instance's delegate when an error in searching for domains or services has occurred. The error dictionary will contain two key/value pairs representing the error domain and code (see the NSNetServicesError enumeration above for error code constants). It is possible for an error to occur after a search has been started successfully.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didNotSearch:(NSDictionary<NSString *, NSNumber *> *)errorDict {
    NSArray *keys = errorDict.allKeys;
    for (NSString *key in keys) {
        NSLog(@"didNotSearch : \n key: %@ \n value: %ld", key, (long)errorDict[key].integerValue);
    }
}

/* Sent to the NSNetServiceBrowser instance's delegate for each domain discovered. If there are more domains, moreComing will be YES. If for some reason handling discovered domains requires significant processing, accumulating domains until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"didFindDomain: %@\n more: %d", domainString, moreComing);
}

/* Sent to the NSNetServiceBrowser instance's delegate for each service discovered. If there are more services, moreComing will be YES. If for some reason handling discovered services requires significant processing, accumulating services until moreComing is NO and then doing the processing in bulk fashion may be desirable.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didFindService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"didFindService: %@\n more: %d", service, moreComing);
//    ESServiceModel *model = [[ESServiceModel alloc] initWithNetService:service];
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered domain is no longer available.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveDomain:(NSString *)domainString moreComing:(BOOL)moreComing {
    NSLog(@"didRemoveDomain: %@\n more: %d", domainString, moreComing);
}

/* Sent to the NSNetServiceBrowser instance's delegate when a previously discovered service is no longer published.
 */
- (void)netServiceBrowser:(NSNetServiceBrowser *)browser didRemoveService:(NSNetService *)service moreComing:(BOOL)moreComing {
    NSLog(@"didRemoveService: %@\n more: %d", service, moreComing);
}

- (NSNetServiceBrowser *)browser {
    if (!_browser) {
        _browser = [[NSNetServiceBrowser alloc] init];
        _browser.delegate = self;
        _browser.includesPeerToPeer = YES;
    }
    return _browser;
}

- (void)dealloc {
    _browser.delegate = nil;
}

@end
