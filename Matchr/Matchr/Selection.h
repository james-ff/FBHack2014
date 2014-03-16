//
//  Selection.h
//  Matchr
//
//  Created by Hani Kazmi on 16/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Selection : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *subSelections;
@end

@interface Selection (CoreDataGeneratedAccessors)

- (void)addSubSelectionsObject:(NSManagedObject *)value;
- (void)removeSubSelectionsObject:(NSManagedObject *)value;
- (void)addSubSelections:(NSSet *)values;
- (void)removeSubSelections:(NSSet *)values;

@end
