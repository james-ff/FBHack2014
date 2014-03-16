//
//  KCLNearbyBroadcastsTableViewController.m
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

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
    if (!_peers) {
        _peers = [[NSMutableArray alloc] init];
    }
    return _peers;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.advertise = ((KCLAppDelegate *)[[UIApplication sharedApplication] delegate]).advertise;
    self.browser = [[MCNearbyServiceBrowser alloc] initWithPeer:self.advertise.localPeerID serviceType:XXServiceType];
    self.browser.delegate = self;
    [self.browser startBrowsingForPeers];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    cell.textLabel.text = ((MCPeerID *)((NSDictionary *)self.peers[indexPath.row])[kID]).displayName;
    cell.detailTextLabel.text = ((NSDictionary *)((NSDictionary *)self.peers[indexPath.row])[kInfo])[@"Interests"];
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (void)browserViewControllerDidFinish:(MCBrowserViewController *)browserViewController {
    
}

@end
