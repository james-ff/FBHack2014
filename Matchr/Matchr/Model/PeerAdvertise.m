//
//  SessionContainer.m
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

@import MultipeerConnectivity;

#import "PeerAdvertise.h"
#import "Transcript.h"


@interface PeerAdvertise()

@property (retain, nonatomic) MCNearbyServiceAdvertiser *serviceAdvertiser;

@end


@implementation PeerAdvertise

#pragma mark - Property methods

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
    if (!_localPeerID) _localPeerID = [[MCPeerID alloc] initWithDisplayName:[[UIDevice currentDevice] name]];
    
    return _localPeerID;
}

- (void)dealloc
{
    [_serviceAdvertiser stopAdvertisingPeer];
    [_session disconnect];
}

- (void)startBroadcasting
{
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.serviceAdvertiser = [[MCNearbyServiceAdvertiser alloc] initWithPeer:self.localPeerID
                                                               discoveryInfo:@{
                                                                               @"Name" : [defaults objectForKey:@"name"],
                                                                               @"Biography" : [defaults objectForKey:@"biography"],
                                                                               @"Interests" : @"Yes, Thor",
                                                                               @"Skills" : @"Objective-C, Ruby"
                                                                               }
                                                                 serviceType:XXServiceType];
    self.serviceAdvertiser.delegate = self;
    [self.serviceAdvertiser startAdvertisingPeer];
}

- (void)stopBroadcasting
{
    [self.serviceAdvertiser stopAdvertisingPeer];
}


#pragma mark - Public methods

// Instance method for sending a string bassed text message to all remote peers
- (Transcript *)sendMessage:(NSString *)message
{
    // Convert the string into a UTF8 encoded data
    NSData *messageData = [message dataUsingEncoding:NSUTF8StringEncoding];
    // Send text message to all connected peers
    NSError *error;
    [self.session sendData:messageData
                   toPeers:self.session.connectedPeers
                  withMode:MCSessionSendDataReliable
                     error:&error];
    
    // Check the error return to know if there was an issue sending data to peers.  Note any peers in the 'toPeers' array argument are not connected this will fail.
    if (error) {
        NSLog(@"Error sending message to peers [%@]", error);
        return nil;
    }
    else {
        // Create a new send transcript
        return [[Transcript alloc] initWithPeerID:_session.myPeerID
                                          message:message
                                        direction:TRANSCRIPT_DIRECTION_SEND];
    }
}

// Method for sending image resources to all connected remote peers.  Returns an progress type transcript for monitoring tranfer
- (Transcript *)sendImage:(NSURL *)imageUrl
{
    NSProgress *progress;
    // Loop on connected peers and send the image to each
    for (MCPeerID *peerID in _session.connectedPeers) {
        // Send the resource to the remote peer.  The completion handler block will be called at the end of sending or if any errors occur
        progress = [self.session sendResourceAtURL:imageUrl
                                          withName:[imageUrl lastPathComponent]
                                            toPeer:peerID
                             withCompletionHandler:^(NSError *error) {
                                 // Implement this block to know when the sending resource transfer completes and if there is an error.
                                 if (error) {
                                     NSLog(@"Send resource to peer [%@] completed with Error [%@]", peerID.displayName, error);
                                 }
                                 else {
                                     // Create an image transcript for this received image resource
                                     Transcript *transcript = [[Transcript alloc] initWithPeerID:_session.myPeerID
                                                                                        imageUrl:imageUrl
                                                                                       direction:TRANSCRIPT_DIRECTION_SEND];
                                     [self.delegate updateTranscript:transcript];
                                 }
                             }];
    }
    
    // Create an outgoing progress transcript.  For simplicity we will monitor a single NSProgress.  However users can measure each NSProgress returned individually as needed
    Transcript *transcript = [[Transcript alloc] initWithPeerID:_session.myPeerID
                                                      imageName:[imageUrl lastPathComponent]
                                                       progress:progress
                                                      direction:TRANSCRIPT_DIRECTION_SEND];
    
    return transcript;
}


#pragma mark - MCSessionDelegate methods

// Helper method for human readable printing of MCSessionState.  This state is per peer.
- (NSString *)stringForPeerConnectionState:(MCSessionState)state
{
    switch (state) {
        case MCSessionStateConnected:
            return @"Connected";
            
        case MCSessionStateConnecting:
            return @"Connecting";
            
        case MCSessionStateNotConnected:
            return @"Not Connected";
    }
}

- (void)advertiser:(MCNearbyServiceAdvertiser *)advertiser didReceiveInvitationFromPeer:(MCPeerID *)peerID withContext:(NSData *)context invitationHandler:(void (^)(BOOL accept, MCSession *session))invitationHandler
{
    invitationHandler(YES, self.session);
}

// Override this method to handle changes to peer session state
- (void)session:(MCSession *)session peer:(MCPeerID *)peerID didChangeState:(MCSessionState)state
{
    NSLog(@"Peer [%@] changed state to %@", peerID.displayName, [self stringForPeerConnectionState:state]);
    
    NSString *adminMessage = [NSString stringWithFormat:@"'%@' is %@", peerID.displayName, [self stringForPeerConnectionState:state]];
    // Create an local transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID
                                                        message:adminMessage
                                                      direction:TRANSCRIPT_DIRECTION_LOCAL];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    if(self.delegate)
        [self.delegate receivedTranscript:transcript];
}

// MCSession Delegate callback when receiving data from a peer in a given session
- (void)session:(MCSession *)session didReceiveData:(NSData *)data fromPeer:(MCPeerID *)peerID
{
    // Decode the incoming data to a UTF8 encoded string
    NSString *receivedMessage = [[NSString alloc] initWithData:data
                                                      encoding:NSUTF8StringEncoding];
    // Create an received transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID
                                                        message:receivedMessage
                                                      direction:TRANSCRIPT_DIRECTION_RECEIVE];
    
    // Notify the delegate that we have received a new chunk of data from a peer
    if(self.delegate)[self.delegate receivedTranscript:transcript];
}

// MCSession delegate callback when we start to receive a resource from a peer in a given session
- (void)session:(MCSession *)session didStartReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID withProgress:(NSProgress *)progress
{
    NSLog(@"Start receiving resource [%@] from peer %@ with progress [%@]", resourceName, peerID.displayName, progress);
    // Create a resource progress transcript
    Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID
                                                      imageName:resourceName
                                                       progress:progress
                                                      direction:TRANSCRIPT_DIRECTION_RECEIVE];
    // Notify the UI delegate
    if(self.delegate) [self.delegate receivedTranscript:transcript];
}

// MCSession delegate callback when a incoming resource transfer ends (possibly with error)
- (void)session:(MCSession *)session didFinishReceivingResourceWithName:(NSString *)resourceName fromPeer:(MCPeerID *)peerID atURL:(NSURL *)localURL withError:(NSError *)error
{
    // If error is not nil something went wrong
    if (error)
    {
        NSLog(@"Error [%@] receiving resource from peer %@ ", [error localizedDescription], peerID.displayName);
    }
    else
    {
        // No error so this is a completed transfer.  The resources is located in a temporary location and should be copied to a permenant locatation immediately.
        // Write to documents directory
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *copyPath = [NSString stringWithFormat:@"%@/%@", [paths objectAtIndex:0], resourceName];
        if (![[NSFileManager defaultManager] copyItemAtPath:[localURL path]
                                                     toPath:copyPath
                                                      error:nil])
        {
            NSLog(@"Error copying resource to documents directory");
        }
        else {
            // Get a URL for the path we just copied the resource to
            NSURL *imageUrl = [NSURL fileURLWithPath:copyPath];
            // Create an image transcript for this received image resource
            Transcript *transcript = [[Transcript alloc] initWithPeerID:peerID
                                                               imageUrl:imageUrl
                                                              direction:TRANSCRIPT_DIRECTION_RECEIVE];
            [self.delegate updateTranscript:transcript];
        }
    }
}

// Streaming API not utilized in this sample code
- (void)session:(MCSession *)session didReceiveStream:(NSInputStream *)stream withName:(NSString *)streamName fromPeer:(MCPeerID *)peerID
{
    NSLog(@"Received data over stream with name %@ from peer %@", streamName, peerID.displayName);
}

@end