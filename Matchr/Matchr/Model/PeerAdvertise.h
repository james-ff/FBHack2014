//
//  SessionContainer.h
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MultipeerConnectivity/MultipeerConnectivity.h>

static NSString * const XXServiceType = @"testC";

@class Transcript;

@protocol SessionContainerDelegate;

@interface PeerAdvertise : NSObject <MCNearbyServiceAdvertiserDelegate, MCSessionDelegate>

@property (retain, nonatomic) MCPeerID *localPeerID;
@property (retain, nonatomic) MCSession *session;

@property (assign, nonatomic) id<SessionContainerDelegate> delegate;

// Method for sending text messages to all connected remote peers.  Returna a message type transcript
- (Transcript *)sendMessage:(NSString *)message;
// Method for sending image resources to all connected remote peers.  Returns an progress type transcript for monitoring tranfer
- (Transcript *)sendImage:(NSURL *)imageUrl;

-(void)stopBroadcasting;
-(void)startBroadcasting;

@end


// Delegate protocol for updating UI when we receive data or resources from peers.
@protocol SessionContainerDelegate <NSObject>

// Method used to signal to UI an initial message, incoming image resource has been received
- (void)receivedTranscript:(Transcript *)transcript;
// Method used to signal to UI an image resource transfer (send or receive) has completed
- (void)updateTranscript:(Transcript *)transcript;

@end
