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
    
    private let frameRatio: CGFloat = UIScreen.main.bounds.width / 375

    // Make text always aligns in vertical
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
    
    func configurate() {
        // Shadow
        let shadow = NSShadow()
        shadow.shadowColor = UIColor.gray
        shadow.shadowBlurRadius = 3.0 * frameRatio
        let typingAttributes: [String: AnyObject] = [NSShadowAttributeName: shadow]
        attributedText = NSAttributedString(string: " ", attributes: typingAttributes)
        
        
        // Those properties need to set after attributedText
        text = ""
        font = UIFont.boldSystemFont(ofSize: 80)
        textAlignment = .center
        spellCheckingType = .no
        backgroundColor = UIColor.clear
        textColor = UIColor.white
        
        // Add padding
        let padding = 3.0 * frameRatio
        textContainerInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        // ** Fix critical bug: Some text is cut a half, since contentSize doesn't update with textContainerInset
        layoutManager.allowsNonContiguousLayout = false
    }
}
