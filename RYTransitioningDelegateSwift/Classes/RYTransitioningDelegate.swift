//
//  RYTransitioningDelegate.swift
//  RYTransitioningDelegateSwift
//
//  Created by RisingSSR on 07/20/2023.
//  Copyright (c) 2023 RisingSSR. All rights reserved.
//

import UIKit

// MARK: RYTransitioningDelegate

open class RYTransitioningDelegate: NSObject {
    
    public var transitionDurationIfNeeded: TimeInterval = 0.3
    
    public var supportedTapOutsideBackWhenPresent: Bool = true
    
    public weak var panGestureIfNeeded: UIPanGestureRecognizer?
    
    public var panInsetsIfNeeded: UIEdgeInsets = .zero
    
    public var heightForPresented: CGFloat? = nil
    
    // if you want sets more inside property, sets those property
    
    public var present: ((RYPresentAnimatedTransitioning) -> ())? = nil
    
    public var dismiss: ((RYDismissAnimatedTransitioning) -> ())? = nil
}

// MARK: UIViewControllerTransitioningDelegate

extension RYTransitioningDelegate: UIViewControllerTransitioningDelegate {
    
    // Animation Supported
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RYPresentAnimatedTransitioning()
        transition.transitionDuration = transitionDurationIfNeeded
        transition.supportedTapOutsideBack = supportedTapOutsideBackWhenPresent
        transition.heightForPresented = heightForPresented
        present?(transition)
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let transition = RYDismissAnimatedTransitioning()
        transition.transitionDuration = transitionDurationIfNeeded
        dismiss?(transition)
        return transition
    }
    
    // Interactive Supported
    
    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let panGestureIfNeeded = panGestureIfNeeded else { return nil }
        let transition = RYPresentDrivenInteractiveTransition(panGesture: panGestureIfNeeded)
        transition.panInsets = panInsetsIfNeeded
        return transition
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let panGestureIfNeeded = panGestureIfNeeded else { return nil }
        let transition = RYDismissDrivenInteractiveTransition(panGesture: panGestureIfNeeded)
        transition.panInsets = panInsetsIfNeeded
        return transition
    }
}
