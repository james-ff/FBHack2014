//
//  KCLSubSelectionTableViewController.m
//  Matchr
//
//  Created by Hani Kazmi on 16/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLSubSelectionTableViewController.h"
#import "SubSelection.h"
#import "Selection.h"
#import "PeerAdvertise.h"
#import "KCLAppDelegate.h"
@interface KCLSubSelectionTableViewController ()
@property (retain, nonatomic) PeerAdvertise *advertise;
@end

@implementation KCLSubSelectionTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    SubSelection *a = [self.selections firstObject];
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *s = [defaults objectForKey:a.parentSelection.name];
    NSLog(s);
    [[NSUserDefaults standardUserDefaults] setValue:@"" forKey:a.parentSelection.name
     ];
    self.advertise = ((KCLAppDelegate *)[[UIApplication sharedApplication] delegate]).advertise;
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
    return [self.selections count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"selection" forIndexPath:indexPath];
    SubSelection *a = self.selections[indexPath.row];
    cell.textLabel.text = a.name;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.advertise stopBroadcasting];
    [[self.tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    SubSelection *a = self.selections[indexPath.row];
    NSString *s = [defaults objectForKey:a.parentSelection.name];
    [defaults setObject:[s stringByAppendingString:[NSString stringWithFormat:@"%@\n", a.name]] forKey:a.parentSelection.name];
    [defaults synchronize];
    
    [self.advertise startBroadcasting];
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

@end
