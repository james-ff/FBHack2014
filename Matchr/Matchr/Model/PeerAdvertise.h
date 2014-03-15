//
//  SessionContainer.h
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString * const XXServiceType = @"testA";


@interface PeerAdvertise : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (readonly, nonatomic, retain) MCPeerID *localPeerID;
@property (readonly, retain) MCSession *session;

@end
