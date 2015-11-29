//
//  User.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/27/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "current-user"
let userDidLoginNotification = "userDidLoginNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagline: String?
    var dictionary: NSDictionary?
    
    init(dictionary: NSDictionary) {
        self.dictionary = dictionary
        
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagline = dictionary["description"] as? String
        
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLoginNotification, object: nil)
    }
    
    class var currentUser: User? {
        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if data != nil {
                    let dictionary = try! NSJSONSerialization.JSONObjectWithData(data!, options: .AllowFragments) as! NSDictionary
                    _currentUser = User(dictionary: dictionary)
                }
            }
        
            return _currentUser
        }
        set(user) {
            _currentUser = user
            
            if _currentUser != nil {
                let data = try! NSJSONSerialization.dataWithJSONObject(user!.dictionary!, options: .PrettyPrinted)
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
            } else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
    class func getCurrentUserInfo(callback callback: (user: User?, error: NSError?) -> Void) {
        
        TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json",
            parameters: nil,
            success: { (operation, response) -> Void in
                let user = User(dictionary: response as! NSDictionary)
                callback(user: user, error: nil)
            }, failure: { (operation, error) -> Void in
                callback(user: nil, error: error)
        })
    }
}