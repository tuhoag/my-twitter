//
//  TweetsViewController.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/27/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tweetButton: UIBarButtonItem!
    var tweets = [Tweet]() {
        didSet{
            tableView.reloadData()
        }
    }
    

    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let attributes = [NSFontAttributeName: UIFont.fontAwesomeOfSize(15)] as Dictionary!
        tweetButton.setTitleTextAttributes(attributes, forState: .Normal)
        tweetButton.title = String.fontAwesomeIconWithName(.Send)
        
        setRefreshControl()
        
        tableView.delegate = self
        tableView.dataSource = self
        loadTweets(callback: nil)
    }

    var refreshControl: UIRefreshControl!
    func setRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview(refreshControl)
    }
    
    func refresh() {
        loadTweets { () -> Void in
            self.refreshControl.endRefreshing()
        }
    }
    
    /**
     load tweets from api
     */
    func loadTweets(callback callback: (() -> Void)?) {
        Tweet.getTweets { (tweets, error) -> Void in
            if callback != nil {
                callback!()
            }
            
            if tweets == nil {
                print("Error when getting tweets:\(error)")
                Helper.showAlert(self, title: "Error", message: "Error when getting tweets.")
                
                return
            }
            
            self.tweets = tweets!
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignout(sender: AnyObject) {
        User.currentUser?.logout()
    }

    @IBAction func onTweet(sender: AnyObject) {
        selectedTweet = nil
        self.performSegueWithIdentifier("replySegue", sender: self)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("tweetCell", forIndexPath: indexPath) as! TweetTableViewCell
        
        cell.tweet = tweets[indexPath.row]
        cell.twitterButtonGroup.replyHandler = { () -> () in
            self.selectedTweet = cell.tweet
            self.performSegueWithIdentifier("replySegue", sender: self)
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("You selected cell number: \(indexPath.row)!")
        selectedTweet = tweets[indexPath.row]
        
        self.performSegueWithIdentifier("detailsSegue", sender: self)
    }

    var selectedTweet: Tweet?

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "replySegue" {
            let vc = segue.destinationViewController as! ReplyViewController
            vc.tweet = selectedTweet
        } else if segue.identifier == "detailsSegue" {
            let vc = segue.destinationViewController as! TweetDetailsViewController
            vc.tweet = selectedTweet
        }

    }


}
