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

// MARK: AnimatedTransitioningDelegate

@objc public protocol AnimatedTransitioningDelegate {
    @objc optional func prepare(_ animatedTransitioning: RYAnimatedTransitioning,
                                for context: UIViewControllerContextTransitioning) -> Void
    
    @objc optional func finished(_ animatedTransitioning: RYAnimatedTransitioning,
                                for context: UIViewControllerContextTransitioning) -> Void
}

// MARK: RYAnimatedTransitioning

open class RYAnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {
    
    public var transitionDuration: TimeInterval = 0.3
    
    public  var delegate: AnimatedTransitioningDelegate?
    
    open func prepare(animate context: UIViewControllerContextTransitioning) {}
    open func prepare(context: UIViewControllerContextTransitioning) {}
    
    open func finished(animate context: UIViewControllerContextTransitioning) {}
    open func finished(context: UIViewControllerContextTransitioning) {}
    
    open func completion(_ context: UIViewControllerContextTransitioning) {
        context.completeTransition(!context.transitionWasCancelled)
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        prepare(animate: transitionContext)
        UIView.animate(withDuration: transitionDuration(using: transitionContext), delay: 0, options: .curveLinear) {
            self.finished(animate: transitionContext)
        } completion: { finished in
            self.completion(transitionContext)
        }
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        transitionDuration
    }
}

// MARK: RYPresentAnimatedTransitioning

open class RYPresentAnimatedTransitioning: RYAnimatedTransitioning {
    
    public var supportedTapOutsideBack: Bool = true
    
    open override func prepare(animate context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        let to = context.viewController(forKey: .to)
        from?.beginAppearanceTransition(false, animated: true)
        if let toView = to?.view {
            context.containerView.addSubview(toView)
        }
        delegate?.prepare?(self, for: context)
    }
    
    open override func prepare(context: UIViewControllerContextTransitioning) {
        let to = context.viewController(forKey: .to)
        var beginFrame = to?.view.frame ?? .zero
        beginFrame.origin.y = context.containerView.frame.maxY
        to?.view.frame = beginFrame
    }
    
    open override func finished(animate context: UIViewControllerContextTransitioning) {
        delegate?.finished?(self, for: context)
    }
    
    open override func finished(context: UIViewControllerContextTransitioning) {
        let to = context.viewController(forKey: .to)
        var endFrame = to?.view.frame ?? .zero
        endFrame.origin.y = context.containerView.frame.size.height - endFrame.size.height
        to?.view.frame = endFrame
    }
    
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
}

// MARK: RYDismissAnimatedTransitioning

open class RYDismissAnimatedTransitioning: RYAnimatedTransitioning {
    
    open override func prepare(animate context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        let to = context.viewController(forKey: .to)
        
        from?.beginAppearanceTransition(false, animated: true)
        to?.beginAppearanceTransition(true, animated: true)
        delegate?.prepare?(self, for: context)
    }
    
    open override func finished(animate context: UIViewControllerContextTransitioning) {
        delegate?.finished?(self, for: context)
    }
    
    open override func finished(context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        
        var endFrame = from?.view.frame ?? .zero
        endFrame.origin.y = context.containerView.frame.origin.y + context.containerView.frame.size.height
        
        from?.view.frame = endFrame
    }
    
    open override func completion(_ context: UIViewControllerContextTransitioning) {
        let from = context.viewController(forKey: .from)
        if !context.transitionWasCancelled {
            from?.view.removeFromSuperview()
        }
        super.completion(context)
    }
}
