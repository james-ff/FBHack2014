//
//  KCLSelectionTableViewController.m
//  Matchr
//
//  Created by Hani Kazmi on 16/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLSelectionTableViewController.h"
#import "Selection.h"
#import "SubSelection.h"
#import "KCLSubSelectionTableViewController.h"

@interface KCLSelectionTableViewController ()

@property (weak, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation KCLSelectionTableViewController

#pragma mark - Properties

- (NSManagedObjectContext *)managedObjectContext
{
    if (!_managedObjectContext) {
        id delegate = [[UIApplication sharedApplication] delegate];
        _managedObjectContext = [delegate managedObjectContext];
    }
    
    return _managedObjectContext;
}


#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup fetchedResultsController
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Selection"];
    request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"name"
                                                              ascending:YES]];
    request.predicate = nil;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:@"DatabaseCache"];
    
}

- (IBAction)createDatabase:(id)sender{
    // Insert new task into model
    NSManagedObjectContext *context = self.managedObjectContext;
    Selection *currentTask = [NSEntityDescription
                              insertNewObjectForEntityForName:@"Selection"
                              inManagedObjectContext:context];
    
                              Selection *a = [NSEntityDescription
                                                        insertNewObjectForEntityForName:@"Selection"
                                                        inManagedObjectContext:context];
    
    
    // Set the task's fields
    currentTask.name = @"Interests";
                              a.name = @"Skills";
    [a addSubSelectionsObject:[self addSelectionWithName:@"iOS"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Android"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Ruby"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Java"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Haskell"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Python"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Prolog"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"Basic"]];
    [a addSubSelectionsObject:[self addSelectionWithName:@"COBOL"]];
    
    [currentTask addSubSelectionsObject:[self addSelectionWithName:@"Books"]];
        [currentTask addSubSelectionsObject:[self addSelectionWithName:@"Music"]];
        [currentTask addSubSelectionsObject:[self addSelectionWithName:@"TV"]];
        [currentTask addSubSelectionsObject:[self addSelectionWithName:@"Sport"]];
        [currentTask addSubSelectionsObject:[self addSelectionWithName:@"Games"]];
                              
    
    
    // Save model
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Couldn't save: %@", [error localizedDescription]);
    }
    
}

- (SubSelection *)addSelectionWithName:(NSString *)string
{
        NSManagedObjectContext *context = self.managedObjectContext;
    SubSelection *b = [NSEntityDescription
                    insertNewObjectForEntityForName:@"SubSelection"
                    inManagedObjectContext:context];
    b.name = string;
    return b;
    
}
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"taskCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    Selection *selection = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = selection.name;
    
    return cell;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"infoSegue"]) {
        Selection *task = [self.fetchedResultsController objectAtIndexPath:[self.tableView indexPathForSelectedRow]];
        KCLSubSelectionTableViewController *vc = (KCLSubSelectionTableViewController *)[segue destinationViewController];
        vc.selections = [task.subSelections allObjects];
    }
    
}

@end