//
//  TwitterClient.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/8/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import Foundation
import OAuthSwift

public class TwitterClient {
    static private var oauthClient : OAuth1Swift!
    
    static func getTwitterClient () -> OAuth1Swift {
        if (TwitterClient.oauthClient == nil) {
            TwitterClient.oauthClient = OAuth1Swift(
                consumerKey:    "jkHzakRHrNbno3yuf0zSfWHv3",
                consumerSecret: "ZZuyB2xoU21ZnzSIvDm8ybu42O10ROn0WReZU33w5eVxaPkmvl",
                requestTokenUrl: "https://api.twitter.com/oauth/request_token",
                authorizeUrl:    "https://api.twitter.com/oauth/authorize",
                accessTokenUrl:  "https://api.twitter.com/oauth/access_token"
            )
            
            if let user = NSUserDefaults.standardUserDefaults().objectForKey("user") {
                TwitterClient.oauthClient.client.credential.oauth_token = user.objectForKey("oauth_token")! as! String
                TwitterClient.oauthClient.client.credential.oauth_token_secret = user.objectForKey("oauth_token_secret")! as! String
            }

        }
        return TwitterClient.oauthClient
    }
}