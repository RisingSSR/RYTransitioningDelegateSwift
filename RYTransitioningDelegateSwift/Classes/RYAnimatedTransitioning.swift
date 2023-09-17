//
//  RYAnimatedTransitioning.swift
//  RYTransitioningDelegateSwift
//
//  Created by RisingSSR on 07/20/2023.
//  Copyright (c) 2023 RisingSSR. All rights reserved.
//

import UIKit

fileprivate extension UIViewController {
    @objc func ry_dismissAnimated() {
        dismiss(animated: true)
    }
}

// MARK: RYAnimatedTransitioning

open class RYAnimatedTransitioning: NSObject {
    
    public typealias AnimationActionBlock = ((UIViewControllerContextTransitioning) -> ())
    
    // - Set those property
    
    /* set the duration of UIView.animate */
    public var transitionDuration: TimeInterval = 0.3
    
    /* set the height for presented */
    public var heightForPresented: CGFloat? = nil
    
    /* will be called before UIView.animate */
    public var prepareAnimationAction: AnimationActionBlock? = nil
    
    /* will be called in animations in UIView.animate */
    public var finishAnimationAction: AnimationActionBlock? = nil
    
    /* will be called in completion in UIView.animate */
    public var completionAnimationAction: AnimationActionBlock? = nil
        
    // - Rewrite those method
    
    /* This function will be dropped before UIView.animate */
    open func prepare(animate context: UIViewControllerContextTransitioning) {
        if let beforeAction = prepareAnimationAction {
            beforeAction(context)
        } else {
            prepareWithBase(context: context)
        }
    }
    
    /* This function will be called in animations in UIView.animate */
    open func finished(animate context: UIViewControllerContextTransitioning) {
        if let finishAction = finishAnimationAction {
            finishAction(context)
        } else {
            finishedWithBase(context: context)
        }
    }
    
    /* This function will be called in completion in UIView.animate */
    open func completion(_ context: UIViewControllerContextTransitioning) {
        if let completionAction = completionAnimationAction {
            completionAction(context)
        } else {
            completionWithBase(context: context)
        }
        context.completeTransition(!context.transitionWasCancelled)
    }
    
    // - Base animation prepare, Rewrite those method
    
    open func prepareWithBase(context: UIViewControllerContextTransitioning) { }
    
    open func finishedWithBase(context: UIViewControllerContextTransitioning) { }
    
    open func completionWithBase(context: UIViewControllerContextTransitioning) { }
}

// MARK: UIViewControllerAnimatedTransitioning

extension RYAnimatedTransitioning: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transitionDuration
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        prepare(animate: transitionContext)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear) {
            self.finished(animate: transitionContext)
        } completion: { finished in
            self.completion(transitionContext)
        }
    }
}

// MARK: RYPresentAnimatedTransitioning

open class RYPresentAnimatedTransitioning: RYAnimatedTransitioning {
            
    public var supportedTapOutsideBack: Bool = true
    
    // - prepare
    
    open override func prepare(animate context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        let to = context.viewController(forKey: .to)
        from?.beginAppearanceTransition(false, animated: true)
        if let toView = to?.view {
            context.containerView.addSubview(toView)
        }
        
        super.prepare(animate: context)
    }
    
    open override func prepareWithBase(context: UIViewControllerContextTransitioning) {
        let to = context.viewController(forKey: .to)
        to?.view.frame.origin.y = context.containerView.frame.maxY
    }
    
    // - finished
    
    open override func finished(animate context: UIViewControllerContextTransitioning) {
        super.finished(animate: context)
    }
    
    open override func finishedWithBase(context: UIViewControllerContextTransitioning) {
        let to = context.viewController(forKey: .to)
        var endHeight = heightForPresented ?? to?.view.frame.height ?? .zero
        to?.view.frame.origin.y = context.containerView.frame.maxY - endHeight
    }
    
    // - completion
    
    open override func completion(_ context: UIViewControllerContextTransitioning) {
        let to = context.viewController(forKey: .to)
        if context.transitionWasCancelled {
            to?.view.removeFromSuperview()
        } else {
            if self.supportedTapOutsideBack, let to {
                let tap = UITapGestureRecognizer(target: to, action: #selector(UIViewController.ry_dismissAnimated))
                context.containerView.addGestureRecognizer(tap)
            }
        }
        super.completion(context)
    }
    
    open override func completionWithBase(context: UIViewControllerContextTransitioning) { }
}

// MARK: RYDismissAnimatedTransitioning

open class RYDismissAnimatedTransitioning: RYAnimatedTransitioning {
    
    // - prepare
    
    open override func prepare(animate context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        let to = context.viewController(forKey: .to)
        
        from?.beginAppearanceTransition(false, animated: true)
        to?.beginAppearanceTransition(true, animated: true)
        
        super.prepare(animate: context)
    }
    
    open override func prepareWithBase(context: UIViewControllerContextTransitioning) { }
    
    // - finished
    
    open override func finished(animate context: UIViewControllerContextTransitioning) {
        super.finished(animate: context)
    }
    
    open override func finishedWithBase(context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        from?.view.frame.origin.y = context.containerView.frame.maxY
    }
    
    // - completion
    
    open override func completion(_ context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        if !context.transitionWasCancelled {
            from?.view.removeFromSuperview()
        }
        super.completion(context)
    }
    
    open override func completionWithBase(context: UIViewControllerContextTransitioning) { }
}
