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
    fileprivate(set) var viewState = ViewState()
    
    struct ViewState {
        var size = CGSize.zero
    }
    
    // Make text always aligns in vertical
    // http://stackoverflow.com/a/33425545/2082851
    override var contentSize: CGSize {
        didSet {
            var topCorrection = (bounds.size.height - contentSize.height * zoomScale) / 2.0
            topCorrection = max(0, topCorrection)
            contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
        }
    }
    
    func getInitState() -> ViewState {
        return ViewState(size: frame.size)
    }
    
    func configurate() {
//        // Shadow
//        let shadow = NSShadow()
//        shadow.shadowColor = UIColor.gray
//        shadow.shadowBlurRadius = 3.0 * frameRatio
//        
//        // Text alignment
//        let paragraphStyle = NSMutableParagraphStyle()
//        paragraphStyle.alignment = NSTextAlignment.center
//        
//        // Create properties
//        let typingAttributes: [String: AnyObject] = [NSForegroundColorAttributeName: UIColor.white,
//                                                     NSShadowAttributeName: shadow,
//                                                     NSParagraphStyleAttributeName:paragraphStyle]
//        attributedText = NSAttributedString(string: " ", attributes: typingAttributes)
//        
//        // Adding NSAttributedString cause font changes to system font
//        font = UIFont.boldSystemFont(ofSize: 20)
//        text = ""
        
        // Add padding
        // textContainerInset = UIEdgeInsets.zero
        // textContainer.lineFragmentPadding = 0
        
        
        
        textAlignment = .center
        spellCheckingType = .no
        backgroundColor = UIColor.clear
        textColor = UIColor.white
        font = UIFont.boldSystemFont(ofSize: 20)

        
        // ** Fix critical bug: Some text is cut a half, since contentSize doesn't update with textContainerInset
        layoutManager.allowsNonContiguousLayout = false
        
        viewState = getInitState()
        updateState(viewState)
        
        for view in subviews {
            view.backgroundColor = UIColor.random
        }
    }
    
    func updateState(_ viewState: ViewState) {
        let oldSize = self.viewState.size
        self.viewState = viewState
        
        frame.size = viewState.size
        let scale = viewState.size.width / oldSize.width
        updateText(withScale: scale)
    }
    
    private func updateText(withScale scale: CGFloat) {
        guard let oldFont = font else { return }
        
        // Container Inset
        var inset = textContainerInset
        textContainerInset = UIEdgeInsets(top: inset.top * scale,
                                          left: inset.left * scale,
                                          bottom: inset.bottom * scale,
                                          right: inset.right * scale)
        
        // Content Inset
        inset = contentInset
        contentInset = UIEdgeInsets(top: inset.top * scale,
                                             left: inset.left * scale,
                                             bottom: inset.bottom * scale,
                                             right: inset.right * scale)
        
        // Line Fragment Padding
        textContainer.lineFragmentPadding = textContainer.lineFragmentPadding * scale
        
        // Font
        let newFont = oldFont.withSize(oldFont.pointSize * scale)
        font = newFont
        text = text
        
        /* if let font = font {
            print("font: \(font)")
            print("ascender: \(font.ascender)")
            print("descender: \(font.descender)")
            print("capHeight: \(font.capHeight)")
            print("xHeight: \(font.xHeight)")
            print("lineHeight: \(font.lineHeight)")
            print("leading: \(font.leading)")
        } */
    }
    
}
