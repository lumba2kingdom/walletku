//
//  RegisterTableViewController.m
//  digipay
//
//  Created by Lutfi Azhar on 1/26/16.
//  Copyright © 2016 Lutfi Azhar. All rights reserved.
//

#import "RegisterTableViewController.h"
#import "Utils.h"

@interface RegisterTableViewController ()

@end

@implementation RegisterTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)premieumSegmented:(UISegmentedControl *)sender {
    switch (self.premiumSegmented.selectedSegmentIndex) {
        case 0:
        {
            [Utils showDefaultAlertWithViewController:self withTitle:@"Syarat & Ketentuan" andMessage:@"1. Biaya Pendaftaran Gratis\n 2. Tidak ada deposit minimal\n 3. Saldo dapat digunakan keseluruh fitur di walletku."];
            [self.noReferralTF setHidden:YES];
        }
            break;
            
        case 1:
        {
            [Utils showDefaultAlertWithViewController:self withTitle:@"Syarat & Ketentuan" andMessage:@"1. Biaya Pendaftaran Gratis\n 2. Deposit minimum Rp 1000.000\n 3. Mendapatkan spanduk toko\n 4. Harga lebih murah daripada normal user\n 5. Berkesempatan mendapatkan point reward\n 6. Dapat merekrut premium user dibawah anda."];
            [self.noReferralTF setHidden:NO];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)daftarBtn:(UIButton *)sender {
    
    
    if (!self.isSignUpAlreadyClicked) {
    
        if ([self.namaTF.text  isEqual: @""] || [self.emailTF.text  isEqual: @""] || [self.alamatTF.text  isEqual: @""] || [self.passwordTF.text  isEqual: @""] || [self.ulangPasswordTF.text isEqual: @""])
        {
            
            self.isSignUpAlreadyClicked = NO;
            
            [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Mohon isi kolom yang kosong"];
        }
        else
        {
            NSString *emailid = self.emailTF.text;
            NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
            NSPredicate *emailPredicate =[NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
            BOOL myStringMatchesRegEx=[emailPredicate evaluateWithObject:emailid];
            
            if (! myStringMatchesRegEx)
            {
                
                [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Alamat email tidak sesuai"];
                
                self.isSignUpAlreadyClicked = NO;
            }else if (![self.passwordTF.text isEqualToString:self.ulangPasswordTF.text]){
                
                [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Password tidak sesuai"];
                
                self.isSignUpAlreadyClicked = NO;
            }else if (!self.pernyataanSwitch.isOn){
                
                [Utils showDefaultAlertWithViewController:self withTitle:@"" andMessage:@"Anda belum menyutujui pernyataan yang tertulis"];
                
                self.isSignUpAlreadyClicked = NO;
            }
            else
            {
                
                UIAlertController * alert=   [UIAlertController
                                              alertControllerWithTitle:@"Cek Data"
                                              message:@"Apakah yakin data sudah benar?"
                                              preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* okBtn = [UIAlertAction
                                        actionWithTitle:@"Ok"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action)
                                        {
                                            self.isSignUpAlreadyClicked = YES;
                                            
                                            NSString *refId = @"";
                                            if ([self.noReferralTF.text isEqualToString:@""]) {
                                                refId = @"";
                                            }else{
                                                refId = self.noReferralTF.text;
                                            }
                                            
                                            NSString *terms = @"";
                                            if (self.pernyataanSwitch.isOn) {
                                                terms = @"true";
                                            }else{
                                                terms = @"false";
                                            }
                                            
                                            [APIClient postAPIWithParam:@{
                                                                          @"user": @{
                                                                                  @"email":self.emailTF.text,
                                                                                  @"name":self.namaTF.text,
                                                                                  @"address":self.alamatTF.text,
                                                                                  @"password":self.passwordTF.text,
                                                                                  @"password_confirmation":self.ulangPasswordTF.text,
                                                                                  @"referral_id":refId,
                                                                                  @"terms":terms
                                                                                  }
                                                                          }andEndPoint:kPostUsers withAuthorization:NO successBlock:^(NSDictionary *response) {
                                                                              
                                                                              
                                                                              User *userData = [User userWithData:response];
                                                                              [Utils addUserToUserDefault:userData];
                                                                              
                                                                              [Utils setPINStatus:@"no"];
                                                                              
                                                                              UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
                                                                              UIViewController * vc = [storyboard instantiateViewControllerWithIdentifier:@"tabBarController"];
                                                                              
                                                                              [self presentViewController:vc animated:YES completion:nil];
                                                                              
                                                                          } andFailureBlock:^(NSString *errorMessage) {
                                                                              
                                                                              [Utils showDefaultAlertWithViewController:self withTitle:@"Error" andMessage:errorMessage];
                                                                              
                                                                              self.isSignUpAlreadyClicked = NO;
                                                                          }];
                                            
                                            
                                        }];
                
                [alert addAction:okBtn];
                
                UIAlertAction* cancelBtn = [UIAlertAction
                                            actionWithTitle:@"Batal"
                                            style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * action)
                                            {
                                                self.isSignUpAlreadyClicked = NO;
                                                
                                            }];
                
                [alert addAction:cancelBtn];
                
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }
    
    
}
@end
