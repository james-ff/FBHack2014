//
//  KCLNearbyBroadcastsTableViewController.m
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

@import MultipeerConnectivity;

#import "KCLNearbyBroadcastsTableViewController.h"
#import "PeerAdvertise.h"
#import "KCLAppDelegate.h"


static NSString * const kID = @"id";
static NSString * const kInfo = @"info";


@interface KCLNearbyBroadcastsTableViewController ()

@property (retain, nonatomic) PeerAdvertise *advertise;
@property (retain, nonatomic) NSMutableArray *peers;
@property (retain, nonatomic) MCNearbyServiceBrowser *browser;

@end


@implementation KCLNearbyBroadcastsTableViewController

- (NSMutableArray *)peers {
    if (!_peers) _peers = [[NSMutableArray alloc] init];
    
    return _peers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (![[[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] allKeys] containsObject:@"initialValuesHaveBeenWritten"])
    {
        [[NSUserDefaults standardUserDefaults] setValue:@"Hani" forKey:@"name"];
        [[NSUserDefaults standardUserDefaults] setValue:@"Lorem ipsum" forKey:@"biography"];
        [[NSUserDefaults standardUserDefaults] setValue:@"TRUE" forKey:@"initialValuesHaveBeenWritten"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    self.advertise = ((KCLAppDelegate *)[[UIApplication sharedApplication] delegate]).advertise;
    [self.advertise startBroadcasting];
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.advertise.localPeerID
                                                    serviceType:XXServiceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.peers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"peerCell" forIndexPath:indexPath];
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    UILabel *biography = (UILabel *)[cell.contentView viewWithTag:20];
    label.text = ((MCPeerID *)self.peers[indexPath.row][kID]).displayName;
    biography.text = self.peers[indexPath.row][kInfo][@"Bigraphy"];
    cell.detailTextLabel.text = self.peers[indexPath.row][kInfo][@"Interests"];
    
    return cell;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    UITableViewCell * cell = (UITableViewCell *)sender;
    NSUInteger row = [self.tableView indexPathForCell:cell].row;
    [self.browser invitePeer:self.peers[row][kID]
                   toSession:self.advertise.session
                 withContext:nil
                     timeout:0];
}


- (void)browser:(MCNearbyServiceBrowser *)browser foundPeer:(MCPeerID *)peerID withDiscoveryInfo:(NSDictionary *)info
{
    if (![self.peers containsObject:[self PeerDictionaryForPeer:peerID]]) {
        [self.peers addObject:@{kID:peerID, kInfo:info}];
    }
    [self.tableView reloadData];
}

- (void)browser:(MCNearbyServiceBrowser *)browser lostPeer:(MCPeerID *)peerID
{
    [self.peers removeObject:[self PeerDictionaryForPeer:peerID]];
    [self.tableView reloadData];
}

-(id)PeerDictionaryForPeer:(MCPeerID *)peer
{
    for (NSDictionary *iPeer in self.peers) {
        if ([iPeer[kID] isEqual:peer]) {
            return iPeer;
        }
    }
    return nil;
}

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController
{
}

@end