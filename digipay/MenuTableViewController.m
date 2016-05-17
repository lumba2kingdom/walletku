//
//  MenuTableViewController.m
//  digipay
//
//  Created by Lutfi Azhar on 1/26/16.
//  Copyright © 2016 Lutfi Azhar. All rights reserved.
//

#import "MenuTableViewController.h"
#import "Constants.h"
#import "APIClient.h"
#import "Utils.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if ([[Utils getPINStatus] isEqualToString:@"no"]) {
        [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Harap ganti PIN Anda terlebih dahulu. PIN lama Anda adalah 1234."];
    }
    
//    [self profileAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //LOGOUT ACTION
    if (indexPath.row == 5) {
        UIAlertController * alert=   [UIAlertController
                                      alertControllerWithTitle:@""
                                      message:@"Apakah Anda yakin?"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* okBtn = [UIAlertAction
                                actionWithTitle:@"Ya"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action)
                                {
                                    //remove session user defaults
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsUserKey];
                                    //remove session token
                                    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kUserDefaultsTokenKey];
                                    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                    UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"loginController"];
                                    [self presentViewController:vc animated:YES completion:nil];
                                    [Utils setPINStatus:@"no"];
                                }];
        
        [alert addAction:okBtn];
        
        UIAlertAction* cancelBtn = [UIAlertAction
                                actionWithTitle:@"Batal"
                                style:UIAlertActionStyleCancel
                                handler:^(UIAlertAction * action)
                                {
                                    
                                    
                                }];
        
        [alert addAction:cancelBtn];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

#pragma mark - API Call Methods
- (void)profileAPI {
    NSString* getUserDataEndPoint = [NSString stringWithFormat:@"%@/%@", kPostUsers, [Utils getUserId]];
    [APIClient getAPIWithParam:nil andEndPoint:getUserDataEndPoint withAuthorization:YES successBlock:^(NSDictionary *response) {
        if (response) {
            
            NSDictionary *userDict = (NSDictionary*)[response objectForKey:@"user"];
            User *newUser = [User userWithData:userDict];
            
            [Utils addUserToUserDefault:newUser];
        }
    } andFailureBlock:^(NSString *errorMessage) {
        [Utils showDefaultAlertWithViewController:self withTitle:@"Profile" andMessage:@"Error getting data from server"];
    }];
}

@end
