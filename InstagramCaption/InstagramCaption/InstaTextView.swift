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
        var clipToBounds = false
    }
    
    func getInitState() -> ViewState {
        return ViewState(size: frame.size, clipToBounds: false)
    }
    
    func configurate() {
        font = UIFont.boldSystemFont(ofSize: 20)
        textAlignment = .center
        spellCheckingType = .no
        backgroundColor = UIColor.clear
        textColor = UIColor.white
        isScrollEnabled = true
        layoutManager.allowsNonContiguousLayout = false
        viewState = getInitState()
    }
    
    func updateState(_ viewState: ViewState) {
        let oldSize = self.viewState.size
        self.viewState = viewState
        
        if viewState.clipToBounds {
            frame.size = viewState.size
            clipsToBounds = viewState.clipToBounds
        }
        else {
            frame.size.width = viewState.size.width
            frame.size.height = max(viewState.size.height, contentSize.height)
            clipsToBounds = viewState.clipToBounds
        }
        
        let scale = viewState.size.width / oldSize.width
        updateText(withScale: scale)
    }
    
    private func updateText(withScale scale: CGFloat) {
        guard let oldFont = font else { return }
        
        // Container Inset
        textContainerInset = UIEdgeInsets(top: textContainerInset.top * scale,
                                          left: textContainerInset.left * scale,
                                          bottom: textContainerInset.bottom * scale,
                                          right: textContainerInset.right * scale)
        
        // Line Fragment Padding
        textContainer.lineFragmentPadding = textContainer.lineFragmentPadding * scale
        
        // Content Inset
        contentInset = UIEdgeInsets(top: (viewState.size.height - contentSize.height) / 2,
                                    left: 0,
                                    bottom: 0,
                                    right: 0)
        
        // Font
        let newFont = oldFont.withSize(oldFont.pointSize * scale)
        font = newFont
        text = text
    }
}
