//
//  MultiStateButton.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/29/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import UIKit
import FontAwesome_swift

class HighlightButton: UIButton {

    var isUserClicked: Bool = false
    var isClicked: Bool = false {
        didSet {
            self.selected = isClicked
            
            if isUserClicked {
                stateChanged?(state: isClicked)
            }
            isUserClicked = false
        }
    }
    
    var stateChanged: ((state: Bool) -> ())?
    var iconStates = [Bool:String]()
    
    required init(coder decoder: NSCoder) {
        super.init(coder: decoder)!
        
        self.addTarget(self, action: "buttonClicked:", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func buttonClicked(sender: HighlightButton!) {
        isUserClicked = true
        isClicked = !isClicked

        print("button clicked: state \(isClicked)")
    }
    
    func setIconForStates(iconForNormal: FontAwesome, colorForNormal: UIColor,  iconForClicked: FontAwesome, colorForClicked: UIColor, fontSize: Int) {
        self.tintColor = self.backgroundColor
        
        self.titleLabel?.font = UIFont.fontAwesomeOfSize(15)
        
        self.setTitle(String.fontAwesomeIconWithName(iconForNormal), forState: UIControlState.Normal)
        self.setTitleColor(colorForNormal, forState: UIControlState.Normal)
        self.backgroundColor = UIColor.whiteColor()
        
        self.setTitle(String.fontAwesomeIconWithName(iconForClicked), forState: UIControlState.Selected)
        self.setTitleColor(colorForClicked, forState: UIControlState.Selected)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
