//
//  TwitterButtonGroupView.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import FontAwesome_swift

@IBDesignable class TwitterButtonGroupView: UIView {
    @IBOutlet weak var favoriteButton: HighlightButton!
    @IBOutlet weak var replyButton: HighlightButton!
    @IBOutlet weak var retweetButton: HighlightButton!
    
    var tweet: Tweet?
    
    // Our custom view from the XIB file
    var view: UIView!
    let nibName = "TwitterButtonGroupView"
    
    var replyHandler: (() -> ())?
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
        
        initButtons()
    }
    
    func initButtons() {
        retweetButton.setIconForStates(FontAwesome.Retweet, colorForNormal: UIColor.blackColor(), iconForClicked: FontAwesome.Retweet, colorForClicked: UIColor.greenColor(), fontSize: 15)
        retweetButton.stateChanged = {(state) -> Void in
            if state == false {
                // the previous state is true, so it's already retweet. dont retweet again
                // just change the value back to true
                self.retweetButton.isClicked = true
                return
            }
            
            Tweet.retweet((self.tweet?.id)!, isGetFullUserInfo: false, callback: { (tweet, error) -> Void in
                if error != nil {
                    print("error when retweet: \(error)")
                    
                    // must change state back to its previous value
                    self.retweetButton.isClicked = !state
                    return
                }
                
                // do nothing
                print("retweet successful")
            })
        }
        
        replyButton.setIconForStates(FontAwesome.Reply, colorForNormal: UIColor.blackColor(), iconForClicked: FontAwesome.Reply, colorForClicked: UIColor.redColor(), fontSize: 15)
        replyButton.stateChanged = {(state) -> Void in
            self.replyHandler?()
        }
        
        favoriteButton.setIconForStates(FontAwesome.HeartO, colorForNormal: UIColor.blackColor(), iconForClicked: FontAwesome.Heart, colorForClicked: UIColor.redColor(), fontSize: 15)
        
        favoriteButton.stateChanged = {(state) -> Void in
            Tweet.favorite((self.tweet?.id)!, state: state) { (tweet, error) -> Void in
                if error != nil {
                    print("error when favorite: \(error)")
                    
                    // must change state back to its previous value
                    self.favoriteButton.isClicked = !state
                    return
                }
                
                // do nothing
                print("favorite successful")
            }

        }
    }
    
    func loadViewFromNib() -> UIView {        
        let bundle = NSBundle(forClass: self.dynamicType)

        let nib = UINib(nibName: nibName, bundle: bundle)
        let temp = nib.instantiateWithOwner(self, options: nil)
        let view = temp[0] as! UIView
        
        return view
    }

    func changeRetweetState(state: Bool) {
        retweetButton.isClicked = state
    }

    func changeFavoriteState(state: Bool) {
        self.favoriteButton.isClicked = state
    }
}
