//
//  LoginViewController.m
//  SecurityApp
//
//  Created by Matthew Dobson on 10/30/14.
//  Copyright (c) 2014 Matthew Dobson. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"

NSString * const clientId = @"1AhUDyALNPK4xgOoKtrjFWysLVB3cvVf";
NSString * const clientSecret = @"MDPzigOPsUDTfFtk";
NSString * const apiUrl = @"http://zetta-instructor.herokuapp.com";
NSString * const oauthEndpoint = @"accesstoken";

@interface LoginViewController ()

- (NSString *)encodeParams:(NSString *)password username:(NSString *)username;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.username.delegate = self;
    self.username.tag = 1;
    [self.username setAutocorrectionType:UITextAutocorrectionTypeNo];
    self.password.delegate = self;
    self.password.tag = 2;
    // Do any additional setup after loading the view.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField.tag == 1) {
        [self.password becomeFirstResponder];
    } else {
        [self performSelector:@selector(login:) withObject:self];
    }
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)encodeParams:(NSString *)password username:(NSString *)username {
    NSDictionary *params = @{@"grant_type":@"password", @"client_id":clientId, @"client_secret":clientSecret, @"username":username, @"password":password};
    
    NSMutableArray *encodedParams = [[NSMutableArray alloc] init];
    for (id key in params) {
        id value = params[key];
        NSString *encoded = [value stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [encodedParams addObject:[NSString stringWithFormat:@"%@=%@", key, encoded]];
    }
    
    return [encodedParams componentsJoinedByString:@"&"];
}

- (IBAction)login:(id)sender {
    NSString *username = self.username.text;
    NSString *password = self.password.text;
    
    NSString *encodedParams = [self encodeParams:password username:username];
    
    NSString *endpoint = [@[apiUrl, oauthEndpoint] componentsJoinedByString:@"/"];
    
    NSURL *url = [NSURL URLWithString:endpoint];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:url];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:[encodedParams dataUsingEncoding:NSUTF8StringEncoding]];

    [NSURLConnection sendAsynchronousRequest:req queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            NSLog(@"ERROR: %@", connectionError);
        } else {
            NSDictionary *returnParams = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            
            
            if ([[returnParams allKeys] containsObject:@"access_token"]) {
                NSLog(@"Access Token: %@", returnParams[@"access_token"]);
                AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
                delegate.accessToken = returnParams[@"access_token"];
                [self performSegueWithIdentifier:@"loggedIn" sender:self];
            } else {
                //NSLog(@"Error: %@", returnParams[@"error_description"]);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:returnParams[@"error_description"] delegate:self cancelButtonTitle:@"Close" otherButtonTitles: nil];
                [alert show];
            }
        }
    }];
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
