//
//  KCLCommonInterestFormViewController.m
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLCommonInterestFormViewController.h"

@interface KCLCommonInterestFormViewController ()
@property (strong, nonatomic) IBOutlet UITextField *interestField;
@end

@implementation KCLCommonInterestFormViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)sendItOutAction:(id)sender {
    if (![self.titleField.text isEqualToString:@""] && ![self.interestField.text isEqualToString:@""]) {
        NSLog(@"Title: %@ Interest: %@", self.titleField.text, self.interestField.text);
    }
}

@end
