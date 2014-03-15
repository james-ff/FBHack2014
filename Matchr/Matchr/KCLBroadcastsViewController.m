//
//  KCLBroadcastsViewController.m
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLBroadcastsViewController.h"
#import "PeerAdvertise.h"

@interface KCLBroadcastsViewController ()

@end

@implementation KCLBroadcastsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(XXServiceType);
    PeerAdvertise *advertise = [[PeerAdvertise alloc] init];
    MCNearbyServiceBrowser *browser = [[MCNearbyServiceBrowser alloc] initWithPeer:advertise.localPeerID serviceType:XXServiceType];
//browser.delegate = self;
    MCBrowserViewController *browserViewController =
    [[MCBrowserViewController alloc] initWithBrowser:browser
                                             session:advertise.session];
    browserViewController.delegate = self;
    [self presentViewController:browserViewController
                       animated:YES
                     completion:
     ^{
         [browser startBrowsingForPeers];
     }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
