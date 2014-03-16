//
//  SessionContainer.m
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "PeerAdvertise.h"


@interface PeerAdvertise()

@property (retain, nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;

@end

@implementation PeerAdvertise

- (MCSession *)session
{
    if (!_session) {
        _session = [[MCSession alloc] initWithPeer:self.localPeerID
                                 securityIdentity:nil
                             encryptionPreference:MCEncryptionNone];
        _session.delegate = self;
    }
    return _session;
}

- (MCPeerID *)localPeerID
{
    if (!_localPeerID) {
        _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    }
    return _localPeerID;
}

- (void)dealloc
{
    [_serviceAdvertiser stopAdvertisingPeer];
}

- (void)stopBroadcasting
{
    [self.serviceAdvertiser stopAdvertisingPeer];
}

- (void)startBroadcasting
{
    self.serviceAdvertiser =         [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                                                       discoveryInfo:@{
                                                                                       @"Interests" : @"Yes, Thor",
                                                                                       @"Skills" : @"Objective-C, Ruby"
                                                                                       }
                                                                         serviceType:XXServiceType];
    _serviceAdvertiser.delegate = self;
    [self.serviceAdvertiser startAdvertisingPeer];
}

#pragma mark - MCNearbyServiceAdvertiserDelegate

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser
didReceiveInvitationFromPeer:(MCPeerID *)peerID
       withContext:(NSData *)context
 invitationHandler:(void(^)(BOOL accept, MCSession *session))invitationHandler
{
          invitationHandler(TRUE, self.session);
}

@end
