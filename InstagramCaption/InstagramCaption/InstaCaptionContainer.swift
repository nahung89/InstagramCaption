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
    
    fileprivate private(set) var viewState =  ViewState()
    fileprivate var lastViewState = ViewState()
    
    fileprivate let kTextSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.width / 2)
    
    fileprivate struct ViewState {
        var transform = CGAffineTransform.identity
        var size = CGSize.zero
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
        textViewContainer.bounds.size = kTextSize
        textViewContainer.clipsToBounds = false
        textViewContainer.backgroundColor = UIColor.clear
        addSubview(textViewContainer)
        
        textView.frame = textViewContainer.bounds
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
        
        viewState = getInitState()
        lastViewState = viewState
        updateState(viewState)
        
        // *Debug
//        textView.text = "Hello world and welcome to another new place in the world. Ha ha ha!"
        textView.alpha = 0.8
        textView.backgroundColor = UIColor.red
        textViewContainer.alpha = 0.8
        textViewContainer.backgroundColor = UIColor.blue
        for view in textView.subviews {
            view.backgroundColor = UIColor.random
        }
        
        textView.updateState(textView.viewState)
    }

    fileprivate func getInitState() -> ViewState {
        var viewState = ViewState()
        viewState.size = kTextSize
        viewState.center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        return viewState
    }
    
    fileprivate func updateState(_ viewState: ViewState) {
        self.viewState = viewState
        textViewContainer.center = viewState.center
        textViewContainer.transform = viewState.transform
        textViewContainer.bounds.size = viewState.size
        
        var textState = textView.viewState
        textState.size = viewState.size
        textView.updateState(textState)
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
            let newWidth = textViewContainer.frame.size.width * gesture.scale
            let shouldTransform = newWidth > UIScreen.main.bounds.width * 2 || newWidth < UIScreen.main.bounds.width / 2
            if shouldTransform {
                viewState.transform = viewState.transform.scaledBy(x: gesture.scale, y: gesture.scale)
            }
            else {
                viewState.size = CGSize(width: viewState.size.width * gesture.scale, height: viewState.size.height * gesture.scale)
            }
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
        guard let textView = textView as? InstaTextView else { return }
        
        // Trick to display full text out of bounds and disable scrolling. Must follow step by step
        var textState = textView.viewState
        textState.size = kTextSize
        textState.clipToBounds = true
        textView.updateState(textState)
        
        var viewState = self.viewState
        lastViewState = viewState
        viewState.center = CGPoint(x: self.bounds.width / 2, y: kTextSize.height / 2 + 50)
        viewState.transform = CGAffineTransform.identity
        viewState.size = kTextSize
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.updateState(viewState)
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        guard let textView = textView as? InstaTextView else { return }
        textView.updateState(textView.viewState)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        guard let textView = textView as? InstaTextView else { return }
        
        // Trick to display full text out of bounds and disable scrolling. Must follow step by step
        var textState = textView.viewState
        textState.size = lastViewState.size
        textState.clipToBounds = false
        textView.updateState(textState)
        
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.updateState(self.lastViewState)
        }
    }
}
