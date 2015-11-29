//
//  TweetTableViewCell.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/27/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage
import FontAwesome_swift

class TweetTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tweetText: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var fullname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    
    @IBOutlet weak var twitterButtonGroup: TwitterButtonGroupView!
    
    var tweet: Tweet? {
        didSet {
            if tweet == nil || tweet!.user == nil {
                return
            }

            tweetText.text = tweet!.text
            fullname.text = tweet!.user!.name
            username.text = "@\(tweet!.user!.screenname!)"
            time.text = Helper.dateDistanceStringFromNow(tweet!.createAt!)
            twitterButtonGroup.tweet = tweet!
            twitterButtonGroup.changeFavoriteState(tweet!.favorited!)
            twitterButtonGroup.changeRetweetState(tweet!.retweeted!)
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
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        
    }
}
