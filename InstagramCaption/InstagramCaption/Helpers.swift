//
//  Helpers.swift
//  InstagramCaption
//
//  Created by NAH on 2/13/17.
//  Copyright © 2017 NAH. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Constant
extension UIColor {
    
    class var random: UIColor {
        let hexColors = [0x02BCA4, 0xFA4985, 0xF2C701]
        return UIColor(netHex: hexColors[Int(arc4random_uniform(UInt32(hexColors.count)))])
    }
    
    convenience init(red: Int, green: Int, blue: Int) {
        let redValue = CGFloat(min(max(0, red), 255)) / 255.0
        let greenValue = CGFloat(min(max(0, green), 255)) / 255.0
        let blueValue = CGFloat(min(max(0, blue), 255)) / 255.0
        self.init(red: redValue, green: greenValue, blue: blueValue, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
}
