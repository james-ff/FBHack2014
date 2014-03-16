//
//  SessionContainer.h
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString * const XXServiceType = @"testB";


@interface PeerAdvertise : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (retain, nonatomic) MCPeerID *localPeerID;
@property (retain, nonatomic) MCSession *session;

-(void)stopBroadcasting;
-(void)startBroadcasting;

@end
