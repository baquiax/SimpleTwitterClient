//
//  LoginViewController.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/8/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import UIKit
import OAuthSwift

public class LoginViewController : UIViewController {
    
    public override func viewDidLoad() {

    }

    @IBAction func loginWithTwitter(sender: AnyObject) {
        TwitterClient.getTwitterClient().authorizeWithCallbackURL (
            NSURL(string: "simple-twitter-client://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
                NSUserDefaults.standardUserDefaults().setObject(parameters, forKey: "user")
                NSUserDefaults.standardUserDefaults().synchronize()
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
        
        
    }
    
    
}