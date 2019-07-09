//
//  SignUpViewController.m
//  offbrand-instagram
//
//  Created by rodrigoandrade on 7/8/19.
//  Copyright © 2019 rodrigoandrade. All rights reserved.
//

#import "SignUpViewController.h"
#import "Parse.h"

@interface SignUpViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signUpButton;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)registerUser {
    // Create signup succesful alert
    UIAlertController *signUpSuccessAlert = [UIAlertController alertControllerWithTitle:@"Signup Successful"
                                                                   message:@"Please login with your new account."
                                                            preferredStyle:(UIAlertControllerStyleAlert)];
    
    // create an OK action
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * _Nonnull action) {
                                                         // handle response here.
                                                     }];
    // add the OK action to the alert controller
    [signUpSuccessAlert addAction:okAction];
    
    // Create unssuccessful signup alert
    UIAlertController *signUpNotSuccessfulAlert = [UIAlertController alertControllerWithTitle:@"Signup not successful"
                                                                                message:@"Please try signing up again."
                                                                         preferredStyle:(UIAlertControllerStyleAlert)];
    // add the OK action to the alert controller
    [signUpNotSuccessfulAlert addAction:okAction];
    
    // initialize a user object
    PFUser *newUser = [PFUser user];
    
    // set user properties
    newUser.username = self.usernameField.text;
    newUser.email = self.emailField.text;
    newUser.password = self.passwordField.text;
    
    // call sign up function on the object
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
        if (error != nil) {
            NSLog(@"Error: %@", error.localizedDescription);
            
            // present signUpNotSuccessfulAlert
            [self presentViewController:signUpNotSuccessfulAlert animated:YES completion:nil];
            
        } else {
            NSLog(@"User registered successfully");
            
            // present signUpSuccessAlert
            [self presentViewController:signUpSuccessAlert animated:YES completion:^(void){
                
                // return to login screen
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        };
    }];
}
- (IBAction)didTapSignUp:(id)sender {
    
    // register user with current text field info
    [self registerUser];
    
    
}
- (IBAction)didTapLogin:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)didTapSignUpView:(id)sender {
    // Close keyboard
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
