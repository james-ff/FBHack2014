//
//  SubSelection.h
//  Matchr
//
//  Created by Hani Kazmi on 16/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Selection;

@interface SubSelection : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Selection *parentSelection;

@end
