//
//  ProfileViewController.m
//  EatSmart
//
//  Created by Larissa Laich on 29.11.14.
//  Copyright (c) 2014 Larissa Laich. All rights reserved.
//

#import "ProfileViewController.h"
#define kPayPalEnvironment PayPalEnvironmentNoNetwork


@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"Profile";

    if(![LocalDataBase UserIsRegistered]){
        [self showPayPalLogin];
    }else{
        [self showProfileView];
        }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) finishedServerCommunication:(NSData *) output fromServer:(int)serverTag{
    if(serverTag == 0){
    if(output){
        NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:output options:0 error:nil];
        NSLog(JSON.description);
        NSNumber *iden = (NSNumber*)[JSON objectForKey:@"userId"];
        [LocalDataBase setUserId:[iden intValue]];
        [self showProfileView];
    }else{
        self.loginButton.alpha = 1;
        self.intro.alpha = 1;
        NSLog(@"nil");
    }
    
    }
    if(serverTag == 1){
        if(output){
            NSDictionary *JSON = [NSJSONSerialization JSONObjectWithData:output options:0 error:nil];
            NSLog(JSON.description);
            User *user = [[User alloc] initWithJSON:JSON];
            NSLog(user.name);
        }else{
            NSLog(@"nil");
        }
        
    }
    
   
}
-(void) showPayPalLogin{
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AeEWUBBptPcT0_TaEVdkHM7OWIl3QYQNr6zlsT8Lul_MDjcz_07hbKAV3dqz"}];
    self.payPalConfig = [[PayPalConfiguration alloc] init];
    self.payPalConfig.acceptCreditCards = YES;
    self.payPalConfig.languageOrLocale = @"en";
    [PayPalMobile initializeWithClientIdsForEnvironments:@{PayPalEnvironmentSandbox : @"AeEWUBBptPcT0_TaEVdkHM7OWIl3QYQNr6zlsT8Lul_MDjcz_07hbKAV3dqz"}];
    self.payPalConfig = [[PayPalConfiguration alloc] init];
    self.payPalConfig.acceptCreditCards = YES;
    self.payPalConfig.languageOrLocale = @"de";
    self.payPalConfig.merchantName = @"MealHub";
    self.payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    self.payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    self.intro=[ [UILabel alloc] initWithFrame:CGRectMake(20,15,self.view.frame.size.width-40,200)];
    self.intro.lineBreakMode = UILineBreakModeWordWrap;
    self.intro.numberOfLines = 0;
    self.intro.text=@"Please login with your Paypal Account";
    self.intro.font=[UIFont fontWithName:@"Helvetica" size:18 ];
    [self.intro setTextAlignment:UITextAlignmentCenter];
    [self.view addSubview:self.intro];
    
    
    self.loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
      self.loginButton.frame = CGRectMake(75, 150, self.view.frame.size.width-150, 66);
    [self.loginButton addTarget:self action:@selector(getUserAuthorizationForProfileSharing:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *btnImage = [UIImage imageNamed:@"loginWithPayPal.png"];
    
    [self.loginButton setBackgroundImage:btnImage forState:UIControlStateNormal];
      self.loginButton.contentMode=UIViewContentModeScaleAspectFit;
    [self.view addSubview:  self.loginButton];
}

-(void) loadUserIdFromServer{
    NSLog(@"casdfsdf");
    ServerCommunication *server = server = [[ServerCommunication alloc] init];
    server.delegate = self;
    server.tag = 0;
    [server loadDataFromServerWithURL:[NSString stringWithFormat:@"%@/user/create",[ServerUrl serverUrl]] andParameters:@"" andHTTPMethod:@"POST"];

}


- (IBAction)getUserAuthorizationForProfileSharing:(id)sender {
    NSSet *scopeValues = [NSSet setWithArray:@[kPayPalOAuth2ScopeOpenId, kPayPalOAuth2ScopeEmail, kPayPalOAuth2ScopeAddress, kPayPalOAuth2ScopePhone]];
    
    PayPalProfileSharingViewController *profileSharingPaymentViewController = [[PayPalProfileSharingViewController alloc] initWithScopeValues:scopeValues configuration:self.payPalConfig delegate:self];
    [self presentViewController:profileSharingPaymentViewController animated:YES completion:nil];
}



- (void)payPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController
             userDidLogInWithAuthorization:(NSDictionary *)profileSharingAuthorization {
    NSLog(@"PayPal Profile Sharing Authorization Success!");
    
    // self.resultText = [profileSharingAuthorization description];
    //[self showSuccess];
    [self sendProfileSharingAuthorizationToServer:profileSharingAuthorization];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidCancelPayPalProfileSharingViewController:(PayPalProfileSharingViewController *)profileSharingViewController {
    NSLog(@"PayPal Profile Sharing Authorization Canceled");
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    //    self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)sendProfileSharingAuthorizationToServer:(NSDictionary *)authorization {
    // TODO: Send authorization to server
 /*
    [self loginWithUser:[ServerDataBaseCommunication userForUUID:@"larissa"]];
    ChooseCharityViewController *charity = [[ChooseCharityViewController alloc] initWithUser:[ServerDataBaseCommunication userForUUID:@"larissa"]];
    [self.navigationController pushViewController:charity animated:YES];
  */
    self.loginButton.alpha = 0;
    self.intro.alpha = 0;
    [self loadUserIdFromServer];
    NSLog(@"succes");
    NSLog(@"Here is your authorization:\n\n%@\n\nSend this to your server to complete profile sharing setup.", authorization);

 
}


-(void) showProfileView{
    NSLog(@"%i",[LocalDataBase userId]);
    ServerCommunication *server = server = [[ServerCommunication alloc] init];
    server.delegate = self;
    server.tag = 1;
    [server loadDataFromServerWithURL:[NSString stringWithFormat:@"%@/user/%i/information",[ServerUrl serverUrl],[LocalDataBase userId]] andParameters:@"" andHTTPMethod:@"GET"];
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
