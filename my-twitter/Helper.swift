//
//  Helper.swift
//  my-twitter
//
//  Created by Anh-Tu Hoang on 11/28/15.
//  Copyright © 2015 hatu. All rights reserved.
//

import Foundation
import UIKit

class Helper: NSObject {
    class func showAlert(container: UIViewController, title: String, message: String) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        
        container.presentViewController(alertView, animated: true, completion: nil)
    }
    
    class func dateDistance(from: NSDate, to: NSDate) -> NSDateComponents {
        let cal = NSCalendar.currentCalendar()

        let durationComponents = cal.components([NSCalendarUnit.Second, NSCalendarUnit.Minute, NSCalendarUnit.Hour, NSCalendarUnit.Day, NSCalendarUnit.Month, NSCalendarUnit.Year], fromDate: from, toDate: to, options: NSCalendarOptions.MatchStrictly)
        
        return durationComponents
    }
    
    class func dateDistanceStringFromNow(from: NSDate) -> String {
        return Helper.dateDistanceString(from, to: NSDate())
    }
    
    class func dateDistanceString(from: NSDate, to: NSDate) -> String {
        let duration = Helper.dateDistance(from, to: to)
        
        var result = ""
        var value = 0
        var unit = ""
        
        if duration.year != 0 {
            value = duration.year
            unit = "year"
        } else if duration.month != 0 {
            value = duration.month
            unit = "month"
        } else if duration.day != 0 {
            value = duration.day
            unit = "day"
        } else if duration.hour != 0 {
            value = duration.hour
            unit = "hour"
        } else if duration.second != 0 {
            value = duration.second
            unit = "second"
        }
        
        if value > 1 {
            unit = "\(unit)s"
        }
        
        if value == 0 {
            result = "just now"
        } else {
            result = "\(value) \(unit)"
        }
        
        return result
    }
}