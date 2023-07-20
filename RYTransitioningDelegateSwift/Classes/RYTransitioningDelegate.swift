//
//  RYTransitioningDelegate.swift
//  RYTransitioningDelegateSwift
//
//  Created by RisingSSR on 07/20/2023.
//  Copyright (c) 2023 RisingSSR. All rights reserved.
//

import UIKit

// MARK: RYTransitioningAnimationDelegate

@objc public protocol RYTransitioningAnimationDelegate {
    
    // Presented
    
    @objc optional
    func prepare(_ transitioningDelegate: RYTransitioningDelegate,
                 withAnimatedTransitioning animatedTransitioning: RYAnimatedTransitioning,
                 forPresented context: UIViewControllerContextTransitioning) -> Void
    
    @objc optional
    func finished(_ transitioningDelegate: RYTransitioningDelegate,
                  withAnimatedTransitioning animatedTransitioning: RYAnimatedTransitioning,
                  forPresented context: UIViewControllerContextTransitioning) -> Void
    
    // Dismissed
    
    @objc optional
    func prepare(_ transitioningDelegate: RYTransitioningDelegate,
                 withAnimatedTransitioning animatedTransitioning: RYAnimatedTransitioning,
                 forDismissed context: UIViewControllerContextTransitioning) -> Void
    
    @objc optional
    func finished(_ transitioningDelegate: RYTransitioningDelegate,
                  withAnimatedTransitioning animatedTransitioning: RYAnimatedTransitioning,
                  forDismissed context: UIViewControllerContextTransitioning) -> Void
}

// MARK: RYTransitioningDelegate

open class RYTransitioningDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    public var transitionDurationIfNeeded: TimeInterval = 0.3
    
    public var supportedTapOutsideBackWhenPresent: Bool = true
    
    public weak var panGestureIfNeeded: UIPanGestureRecognizer?
    
    public var panInsetsIfNeeded: UIEdgeInsets = .zero
    
    public weak var delegate: RYTransitioningAnimationDelegate?
    
    // Animation Supported
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RYPresentAnimatedTransitioning()
        transition.transitionDuration = transitionDurationIfNeeded
        transition.supportedTapOutsideBack = supportedTapOutsideBackWhenPresent
        transition.delegate = self
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RYDismissAnimatedTransitioning()
        transition.transitionDuration = transitionDurationIfNeeded
        transition.delegate = self
        return transition
    }
    
    // Interactive Supported
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let panGestureIfNeeded else { return nil }
        let transition = RYPresentDrivenInteractiveTransition(panGesture: panGestureIfNeeded)
        transition.panInsets = panInsetsIfNeeded
        return transition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let panGestureIfNeeded else { return nil }
        let transition = RYDismissDrivenInteractiveTransition(panGesture: panGestureIfNeeded)
        transition.panInsets = panInsetsIfNeeded
        return transition
    }
}

// MARK: AnimatedTransitioningDelegate

extension RYTransitioningDelegate: AnimatedTransitioningDelegate {
        
    public func prepare(_ animatedTransitioning: RYAnimatedTransitioning, for context: UIViewControllerContextTransitioning) {
        if let delegate {
            if animatedTransitioning.classForCoder is RYPresentAnimatedTransitioning.Type {
                delegate.prepare?(self, withAnimatedTransitioning: animatedTransitioning, forPresented: context)
            } else if animatedTransitioning.classForCoder is RYDismissAnimatedTransitioning.Type {
                delegate.prepare?(self, withAnimatedTransitioning: animatedTransitioning, forDismissed: context)
            }
        } else {
            animatedTransitioning.prepare(context: context)
        }
    }
    
    public func finished(_ animatedTransitioning: RYAnimatedTransitioning, for context: UIViewControllerContextTransitioning) {
        if let delegate {
            if animatedTransitioning.classForCoder is RYPresentAnimatedTransitioning.Type {
                delegate.finished?(self, withAnimatedTransitioning: animatedTransitioning, forPresented: context)
            } else if animatedTransitioning.classForCoder is RYDismissAnimatedTransitioning.Type {
                delegate.finished?(self, withAnimatedTransitioning: animatedTransitioning, forDismissed: context)
            }
        } else {
            animatedTransitioning.finished(context: context)
        }
    }
}
