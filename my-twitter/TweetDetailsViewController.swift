//
//  TweetDetailsViewController.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/30/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import Alamofire

class TweetDetailsViewController: UIViewController {

    @IBOutlet weak var twitterButtonGroupView: TwitterButtonGroupView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var favoriteCountLabel: UILabel!
    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    var tweet: Tweet? {
        didSet {
            reloadFormData()
        }
    }
    
    func reloadFormData() {
        if tweetText == nil {
            return
        }
        
        tweetText.text = tweet!.text!
        createdDateLabel.text = tweet!.createdAtString!
        screennameLabel.text = tweet!.user!.screenname!
        nameLabel.text = tweet!.user!.name!
        favoriteCountLabel.text = String(tweet!.favoritedCount!)
        retweetCountLabel.text = String(tweet!.retweetedCount!)
        
        twitterButtonGroupView.tweet = tweet!
        twitterButtonGroupView.changeFavoriteState(tweet!.favorited!)
        twitterButtonGroupView.changeRetweetState(tweet!.retweeted!)
        
        Alamofire.request(Method.GET, tweet!.user!.profileImageUrl!)
            .responseImage { response in
                
                if let image = response.result.value {
                    self.avatarImage.image = image
                } else {
                    print("error when getting profile image: \(response.result.error!)")
                    return
                }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()


        // Do any additional setup after loading the view.
        reloadFormData()
        twitterButtonGroupView.replyHandler = { () -> () in
            self.performSegueWithIdentifier("replySegue", sender: self)
        }
        
        Tweet.getTweet(tweet!.id!) { (tweet, error) -> Void in
            if error != nil {
                print("Error when getting tweet by id: \(error)")
                return
            }
            
            print("Get tweet by id successfully")
            self.tweet = tweet
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "replySegue" {
            let vc = segue.destinationViewController as! ReplyViewController
            vc.tweet = tweet
        }
    }


}
