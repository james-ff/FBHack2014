//
//  KCLiBroadcastViewController.m
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLiBroadcastViewController.h"

@interface KCLiBroadcastViewController () <UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UIButton *broadcastButton;
@property (nonatomic) BOOL isBroadcasting;
@end

@implementation KCLiBroadcastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self.tabBarController.tabBar setTranslucent:NO];
    
    self.isBroadcasting = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)broadcastAction:(id)sender {
    if (self.isBroadcasting) {
        NSLog(@"Stopping Broadcasting");
        // TODO: Actually stop boradcasting
        self.isBroadcasting = NO;
        [self.broadcastButton setTitle:@"Start Broadcasting" forState:UIControlStateNormal];
    } else {
        UIActionSheet *actionView = [[UIActionSheet alloc] initWithTitle:@"Start looking for someone with a:"
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:@"Set of skills", @"Common interest",  nil];
        [actionView showInView:self.view];
    }
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        [self.broadcastButton setTitle:@"Stop Broadcasting" forState:UIControlStateNormal];
    }
    if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Set of skills"]) {
        [self performSegueWithIdentifier:@"skillsForm" sender:self];
    } else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqualToString:@"Common interest"]) {
        [self performSegueWithIdentifier:@"interestForm" sender:self];
    }
}

@end
