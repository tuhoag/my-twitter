//
//  TwitterClient.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/26/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import Foundation
import BDBOAuth1Manager


let twitterConsumerKey = "AOwf5k2vDEnJ3LMrqp8SYoXli"
let twitterConsumerSecret = "Eg839YZF5YcpMmlZiRFhxbV9ZnkoHKR3ZN2hskjN43jVTPj9Ei"
let twitterBaseUrl = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseUrl, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        
        return Static.instance
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token",
            method: "GET",
            callbackURL: NSURL(string: "bdboauth://oauth"),
            scope: nil,
            success: {(requestToken) -> Void in
                print("Got the request token: \(requestToken.token)")
                let authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            },
            failure: { (error) -> Void in
                print("fail to get request token \(error)")
                self.loginCompletion?(user: nil, error: error)
            }
        )
    }
    
    func openUrl(url: NSURL?) {
        let urlComponents = NSURLComponents(URL: url!, resolvingAgainstBaseURL: true)!

        let deniedToken = (urlComponents.queryItems?.filter({ (item) -> Bool in
            item.name == "denied"
        }))?.first?.value
        
        if deniedToken != nil {
            self.loginCompletion?(user: nil, error: NSError(domain: "User denied authorization", code: 1, userInfo: [:]))
            return
        }
        
          //  .filter({ (item) in item.name == "denied" }).first!
        
        TwitterClient.sharedInstance.fetchAccessTokenWithPath("oauth/access_token",
            method: "POST",
            requestToken: BDBOAuth1Credential(queryString: url!.query),
            success: { (accessToken) -> Void in
                print ("got access token \(accessToken.token)")
                TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
                
                User.getCurrentUserInfo(callback: { (user, error) -> Void in
                    if user == nil {
                        self.loginCompletion?(user: nil, error: error)
                        return
                    }
                    
                    User.currentUser = user
                    self.loginCompletion?(user: user, error: nil)
                })
            }) { (error) -> Void in
                print("fail get access token")
                self.loginCompletion?(user:nil, error: error)
        }
        
    }
}