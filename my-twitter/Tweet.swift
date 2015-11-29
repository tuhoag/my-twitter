//
//  Tweet.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/27/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var id: Int?
    var user: User?
    var text: String?
    var createdAtString: String?
    var createAt: NSDate?
    var favorited: Bool?
    var retweeted: Bool?
    var retweetedCount: Int?
    var favoritedCount: Int?
    
    init(dictionary: NSDictionary) {
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        
        let formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createAt = formatter.dateFromString(createdAtString!)
        
        favorited = dictionary["favorited"] as? Bool
        id = dictionary["id"] as? Int
        retweeted = dictionary["retweeted"] as? Bool
        retweetedCount = dictionary["retweet_count"] as? Int
        favoritedCount = dictionary["favorite_count"] as? Int
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    class func getTweets(callback: (tweets: [Tweet]?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.GET("1.1/statuses/home_timeline.json",
            parameters: nil,
            success: { (operation, response) -> Void in
                let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
                
                for tweet in tweets {
                    print(tweet)
                }
                
                callback(tweets: tweets, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweets: nil, error: error)
        })
    }
    
    class func retweet(tweetId: Int, isGetFullUserInfo: Bool, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.POST("1.1/statuses/retweet/\(tweetId).json",
            parameters: [
                "trim_user": isGetFullUserInfo
                ] as AnyObject,
            success: { (operation, response) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                print(tweet)
                
                callback(tweet: tweet, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweet: nil, error: error)
        })

    }
    
    class func favorite(tweetId: Int, state: Bool, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.POST("1.1/favorites/create.json",
            parameters: [
                "id": tweetId,
                "include_entities": state
            ] as AnyObject,
            success: { (operation, response) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                print(tweet)
                
                callback(tweet: tweet, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweet: nil, error: error)
        })
    }
    
    class func tweet(status: String, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json",
            parameters: [
                "status": status
                ] as AnyObject,
            success: { (operation, response) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                print(tweet)
                
                callback(tweet: tweet, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweet: nil, error: error)
        })
    }
    
    class func reply(status: String, tweetId: Int, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.POST("1.1/statuses/update.json",
            parameters: [
                "status": status,
                "in_reply_to_status_id": tweetId
                ] as AnyObject,
            success: { (operation, response) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                print(tweet)
                
                callback(tweet: tweet, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweet: nil, error: error)
        })
    }
    
    class func getTweet(tweetId: Int, callback: (tweet: Tweet?, error: NSError?) -> Void) {
        TwitterClient.sharedInstance.GET("1.1/statuses/show.json",
            parameters: [
                "id": tweetId
                ] as AnyObject,
            success: { (operation, response) -> Void in
                let tweet = Tweet(dictionary: response as! NSDictionary)
                print(tweet)
                
                callback(tweet: tweet, error: nil)
            },
            failure: { (operation, error) -> Void in
                callback(tweet: nil, error: error)
        })
    }
}