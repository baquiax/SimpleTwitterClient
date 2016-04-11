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
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var lastLogin: UILabel!
    let dateFormatter = NSDateFormatter()
    
    public override func viewDidLoad() {
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm"
        if let user = NSUserDefaults.standardUserDefaults().objectForKey("user") {
            self.userName.text = user.objectForKey("screen_name") as? String
        }
        
        if let lastLoginDate = NSUserDefaults.standardUserDefaults().objectForKey("lastLogin") as? NSDate {
            let str = self.dateFormatter.stringFromDate(lastLoginDate)
            self.lastLogin.text = str
        }
    }

    @IBAction func loginWithTwitter(sender: AnyObject) {
        TwitterClient.getTwitterClient().authorizeWithCallbackURL (
            NSURL(string: "simple-twitter-client://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
                self.userName.text = parameters["screen_name"]
                let str = self.dateFormatter.stringFromDate(NSDate())
                self.lastLogin.text = str
                NSUserDefaults.standardUserDefaults().setObject(parameters, forKey: "user")
                NSUserDefaults.standardUserDefaults().setObject(NSDate(), forKey: "lastLogin")
                NSUserDefaults.standardUserDefaults().synchronize()
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
        
        
    }
    
    
}