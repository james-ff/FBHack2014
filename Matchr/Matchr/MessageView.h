//
//  MessageView.h
//  Matchr
//
//  Created by Hani Kazmi on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Transcript;


// TAG used in our custom table view cell to retreive this view
#define MESSAGE_VIEW_TAG (99)


@interface MessageView : UIView

@property (nonatomic, assign) Transcript *transcript;

// Class method for computing a view height based on a given message transcript
+ (CGFloat)viewHeightForTranscript:(Transcript *)transcript;

@end