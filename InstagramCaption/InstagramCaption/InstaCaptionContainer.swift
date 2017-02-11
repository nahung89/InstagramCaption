//
//  InstaCaptionContainer.swift
//  InstagramCaption
//
//  Created by NAH on 2/11/17.
//  Copyright © 2017 NAH. All rights reserved.
//

import Foundation
import UIKit

class InstaCaptionContainer: UIView {
    
    fileprivate var textViewContainer = UIView()
    fileprivate var textView = InstaTextView()
    
    fileprivate var pinchGesture: UIPinchGestureRecognizer!
    fileprivate var panGesture: UIPanGestureRecognizer!
    fileprivate var rotateGesture: UIRotationGestureRecognizer!
    fileprivate var tapGesture: UITapGestureRecognizer!
    
    fileprivate var originalCenterPoint = CGPoint.zero
    fileprivate var originalTransform = CGAffineTransform.identity
    fileprivate private(set) var viewState =  ViewState()
    
    fileprivate let defaultTextSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
    
    fileprivate struct ViewState {
        var transform = CGAffineTransform.identity
        var center = CGPoint.zero
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configurate()
    }
    
    override func becomeFirstResponder() -> Bool {
        return textView.becomeFirstResponder()
    }
    
    override func resignFirstResponder() -> Bool {
        return textView.resignFirstResponder()
    }
    
    func configurate() {
        textViewContainer.frame = bounds
        textViewContainer.bounds.size = defaultTextSize
        textViewContainer.clipsToBounds = false
        textViewContainer.backgroundColor = UIColor.clear
        addSubview(textViewContainer)
        
        textView.frame = textViewContainer.bounds
        textView.backgroundColor = UIColor.clear
        textView.delegate = self
        textView.configurate()
        textViewContainer.addSubview(textView)
        
        pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(handlePinGesture(_:)))
        addGestureRecognizer(pinchGesture)
        pinchGesture.delegate = self
        
        rotateGesture = UIRotationGestureRecognizer(target: self, action: #selector(handleRotateGesture(_:)))
        addGestureRecognizer(rotateGesture)
        rotateGesture.delegate = self
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGesture)
        panGesture.delegate = self
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        
        viewState.center = CGPoint(x: bounds.width / 2, y: defaultTextSize.width / 2)
        
        // *Debug
         //textView.backgroundColor = UIColor.red
         //textViewContainer.backgroundColor = UIColor.blue
    }

    fileprivate func updateState(_ viewState: ViewState) {
        self.viewState = viewState
        textViewContainer.center = viewState.center
        textViewContainer.transform = viewState.transform
    }
}

// MARK: - UIGestureRecognizer Delegate
extension InstaCaptionContainer: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return gestureRecognizer.view?.isKind(of: UITextView.classForCoder()) == false &&
            otherGestureRecognizer.view?.isKind(of: UITextView.classForCoder()) == false
    }
}

// MARK: - Gesture Handler
extension InstaCaptionContainer {
    
    func handleTapGesture(_ gesture: UIPanGestureRecognizer) {
        textView.resignFirstResponder()
    }
    
    func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            textView.resignFirstResponder()
        case .changed:
            var viewState = self.viewState
            let translation = gesture.translation(in: gesture.view)
            let newCenter = CGPoint(x: viewState.center.x + translation.x, y: viewState.center.y + translation.y)
            viewState.center = newCenter
            updateState(viewState)
            gesture.setTranslation(CGPoint.zero, in: gesture.view)
        default:
            break
        }
    }
    
    func handlePinGesture(_ gesture: UIPinchGestureRecognizer) {
        switch gesture.state {
        case .began:
            textView.resignFirstResponder()
        case .changed:
            var viewState = self.viewState
            viewState.transform = viewState.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            updateState(viewState)
            gesture.scale = 1
        default:
            break
        }
    }
    
    func handleRotateGesture(_ gesture: UIRotationGestureRecognizer) {
        switch gesture.state {
        case .began:
            textView.resignFirstResponder()
        case .changed:
            var viewState = self.viewState
            viewState.transform = viewState.transform.rotated(by: gesture.rotation)
            updateState(viewState)
            gesture.rotation = 0
        default:
            break
        }
    }
}

// MARK: - UITextView Delegate
extension InstaCaptionContainer: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        // Trick to display text in center of height (vertical alignment). Must follow step by step
        textView.bounds.size = textViewContainer.bounds.size
        textView.clipsToBounds = true
        textView.isScrollEnabled = true
        
        var viewState = self.viewState
        originalCenterPoint = viewState.center
        originalTransform = viewState.transform
        viewState.center = CGPoint(x: self.bounds.width / 2, y: defaultTextSize.height / 2)
        viewState.transform = CGAffineTransform.identity
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.updateState(viewState)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // Trick to display full text out of bounds and disable scrolling. Must follow step by step
        let contentSize = textView.contentSize
        textView.clipsToBounds = false
        textView.isScrollEnabled = false
        textView.bounds.size = contentSize
        
        var viewState = self.viewState
        viewState.center = self.originalCenterPoint
        viewState.transform = self.originalTransform
        
        UIView.animate(withDuration: 0.3) { [unowned self] in
            self.updateState(viewState)
        }
    }
}
