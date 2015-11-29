//
//  ViewController.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/26/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func onClickLoginButton(sender: AnyObject) {
        TwitterClient.sharedInstance.loginWithCompletion() {
            (user: User?, error:NSError?) in
            
            if user == nil {
                print("error:\(error)")
                let alertView = UIAlertController(title: "Login Error", message: "Cannot log in with Twitter", preferredStyle: .Alert)
                alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
                
                self.presentViewController(alertView, animated: true, completion: nil)
                
                return
            }

            self.performSegueWithIdentifier("loginSegue", sender: self)
        }
    }
    
}

