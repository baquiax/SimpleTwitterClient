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
    var oauthSwift : OAuth1Swift!;
    
    public override func viewDidLoad() {
        self.oauthSwift = OAuth1Swift(
            consumerKey:    "jkHzakRHrNbno3yuf0zSfWHv3",
            consumerSecret: "ZZuyB2xoU21ZnzSIvDm8ybu42O10ROn0WReZU33w5eVxaPkmvl",
            requestTokenUrl: "https://api.twitter.com/oauth/request_token",
            authorizeUrl:    "https://api.twitter.com/oauth/authorize",
            accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
        )
    }

    @IBAction func loginWithTwitter(sender: AnyObject) {
        self.oauthSwift.authorizeWithCallbackURL (
            NSURL(string: "simple-twitter-client://oauth-callback/twitter")!,
            success: { credential, response, parameters in
                print(credential.oauth_token)
                print(credential.oauth_token_secret)
                print(parameters["user_id"])
                self.oauthSwift.client.get("https://api.twitter.com/1.1/friends/ids.json", parameters: ["user_id" : parameters["user_id"]!], headers: nil, success: { data, response in
                    let datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print(datastring)
                    }, failure: { (error) -> Void in
                        
                })
            },
            failure: { error in
                print(error.localizedDescription)
            }
        )
        
        
    }
    
    
}