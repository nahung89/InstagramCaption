//
//  InstaTextView.swift
//  InstagramCaption
//
//  Created by NAH on 2/11/17.
//  Copyright © 2017 NAH. All rights reserved.
//

import Foundation
import UIKit

class InstaTextView: UITextView {
    
    private let frameRatio = UIScreen.main.bounds.width / 375
    
    // Make text always aligns in vertical
    // http://stackoverflow.com/a/33425545/2082851
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
    
    func configurate() {
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.0 * frameRatio
        // Text alignment
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.center
        // Create properties
        let typingAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.white,
                                                     NSShadowAttributeName: shadow,
                                                     NSParagraphStyleAttributeName:paragraphStyle]
        attributedText = NSAttributedString(string: " ", attributes: typingAttributes)
        
        // Adding NSAttributedString cause font changes to system font
        font = UIFont.boldSystemFont(ofSize: 40)
        text = ""
        spellCheckingType = .no
        
        // Add padding
        let padding = 3.0 * frameRatio
        textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        // ** Fix critical bug: Some text is cut a half, since contentSize doesn't update with textContainerInset
        layoutManager.allowsNonContiguousLayout = false
    }
    
}
