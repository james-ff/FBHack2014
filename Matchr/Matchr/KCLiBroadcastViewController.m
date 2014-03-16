//
//  KCLiBroadcastViewController.m
//  Matchr
//
//  Created by James Bellamy on 15/03/2014.
//  Copyright (c) 2014 KCL. All rights reserved.
//

#import "KCLiBroadcastViewController.h"
#import "KCLAppDelegate.h"
#import "PeerAdvertise.h"

@interface KCLiBroadcastViewController ()

@property (retain, nonatomic) PeerAdvertise *advertise;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;

@end


@implementation KCLiBroadcastViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    self.nameTextField.text = [defaults objectForKey:@"name"];
    self.biographyTextView.text = [defaults objectForKey:@"biography"];
    self.biographyTextView.delegate = self;
    self.advertise = ((KCLAppDelegate *)[[UIApplication sharedApplication] delegate]).advertise;
    
    // Do any additional setup after loading the view.
    
    //[self.navigationController.navigationBar setTranslucent:NO];
    //[self.tabBarController.tabBar setTranslucent:NO];
    
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

- (IBAction)enterName:(UITextField *)sender {
    [self.advertise stopBroadcasting];
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    [defaults setObject:sender.text forKey:@"name"];
    [defaults synchronize];
    [self.advertise startBroadcasting];
}
- (IBAction)dissmissKeyboard:(UITextField *)sender {
        [sender resignFirstResponder];
}
-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

        return NO;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (textView == self.biographyTextView) {
        if ([text isEqualToString:@"\n"]) {
            [self.advertise stopBroadcasting];
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults setObject:textView.text forKey:@"biography"];
            [defaults synchronize];
            [self.advertise startBroadcasting];
            [textView resignFirstResponder];
            return NO;
        }
    }
    return YES;
}
@end