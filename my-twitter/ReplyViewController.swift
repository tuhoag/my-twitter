//
//  ReplyViewController.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController {

    @IBOutlet weak var tweetText: UITextView!
    
    var tweet: Tweet?
    
    @IBAction func onCancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onReply(sender: AnyObject) {
        if tweet != nil {
            // reply
            Tweet.reply(tweetText.text, tweetId: tweet!.id!) { (tweet, error) -> Void in
                if error != nil {
                    print ("Error when reply: \(error)")
                    return
                }
                
                //
                print("reply successfull")
                self.dismissViewControllerAnimated(true, completion: nil)
            }
            
            return
        }
        
        // tweet new status
        Tweet.tweet(tweetText.text) { (tweet, error) -> Void in
            if error != nil {
                print ("Error when tweet: \(error)")
                return
            }
            
            //
            print("tweet successfull")
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if tweet != nil {
            tweetText.text = "@\(tweet!.user!.screenname!)"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
