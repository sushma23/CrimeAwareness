//
//  Helper.swift
//  Awareness
//
//  Created by Sushma on 3/31/16.
//  Copyright © 2016 Sush. All rights reserved.
//

import Foundation

class Helper: NSObject {
    //sort dictionary ByValue
    static let sortByValue = {
        (elem1:(key: String, val: Int), elem2:(key: String, val: Int)) -> Bool in
        if elem1.val > elem2.val {
            return true
        } else if elem1.val == elem2.val {
            if elem1.key > elem2.key {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    
    class func isDateWithinPast30Days(dateInString: String) -> Bool {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss"
        let date = dateFormatter.dateFromString(dateInString)!
        
        if date.compare(past30Days) == NSComparisonResult.OrderedDescending {
            //"Date1 is Later than Date2"
            return true
        }
        else if date.compare(past30Days) == NSComparisonResult.OrderedAscending {
            // "Date1 is Earlier than Date2"
            return false
        }
        else if date.compare(past30Days) == NSComparisonResult.OrderedSame {
            return true
        }
        return false
    }
    
    class var past30Days: NSDate {
        return NSCalendar.currentCalendar().dateByAddingUnit(.Day, value: -30, toDate: NSDate(), options: [])!
    }

}
