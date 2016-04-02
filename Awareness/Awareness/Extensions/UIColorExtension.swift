//
//  UIColorExtension.swift
//  Awareness
//
//  Created by Sushma on 3/31/16.
//  Copyright © 2016 Sush. All rights reserved.
//
import UIKit

extension UIColor {
    
    public convenience init(hex: String) {
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0
        
        if hex.hasPrefix("#") {
            let stripped = hex.substringFromIndex(hex.startIndex.advancedBy(1))
            let scanner = NSScanner(string: stripped);
            var hexValue: CUnsignedLongLong = 0
            if scanner.scanHexLongLong(&hexValue) {
                if stripped.characters.count == 6 {
                    red   = CGFloat((hexValue & 0xFF0000) >> 16) / 255.0
                    green = CGFloat((hexValue & 0x00FF00) >> 8)  / 255.0
                    blue  = CGFloat(hexValue & 0x0000FF) / 255.0
                } else if stripped.characters.count == 8 {
                    red   = CGFloat((hexValue & 0xFF000000) >> 24) / 255.0
                    green = CGFloat((hexValue & 0x00FF0000) >> 16) / 255.0
                    blue  = CGFloat((hexValue & 0x0000FF00) >> 8)  / 255.0
                    alpha = CGFloat(hexValue & 0x000000FF)         / 255.0
                } else {
                    debugPrint("invalid rgb string, length should be 7 or 9")
                }
            } else {
                debugPrint("scan hex error")
            }
        } else {
            debugPrint("invalid rgb string, missing '#' as prefix")
        }
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    
    
    public class Awareness {
        public class var Red:             UIColor { return UIColor(hex: "#ff0000") }
        public class var PureRed:         UIColor { return UIColor(hex: "#eb3600") }
        public class var PureOrange:      UIColor { return UIColor(hex: "#e54800") }
        public class var StrongOrangeA:   UIColor { return UIColor(hex: "#d86d00") }
        public class var StrongOrangeB:   UIColor { return UIColor(hex: "#d27f00") }
        public class var StrongYellowA:   UIColor { return UIColor(hex: "#c5a300") }
        public class var StrongYellowB:   UIColor { return UIColor(hex: "#b9c800") }
        public class var PureGreen:       UIColor { return UIColor(hex: "#a6ff00") }
    }
}
