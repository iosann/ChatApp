//
//  PopAnimator.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.05.2022.
//

import UIKit

protocol IPopAnimator {
    var isPresenting: Bool { get set }
    var originFrame: CGRect { get set }
    var dismissCompletion: (() -> Void)? { get set }
}

class PopTransitionAnimator: NSObject, IPopAnimator, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    var isPresenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let viewToPresent = isPresenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from)
        guard let viewToPresent = viewToPresent else {
            transitionContext.completeTransition(false)
            return
        }
        let initialFrame = isPresenting ? originFrame : viewToPresent.frame
        let finalFrame = isPresenting ? viewToPresent.frame : originFrame
        let xScaleFactor = isPresenting
                            ? initialFrame.width / finalFrame.width
                            : finalFrame.width / initialFrame.width
        let yScaleFactor = isPresenting
                            ? initialFrame.height / finalFrame.height
                            : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if isPresenting {
            viewToPresent.transform = scaleTransform
            viewToPresent.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            viewToPresent.clipsToBounds = true
        }
        if let toView = transitionContext.view(forKey: .to) { containerView.addSubview(toView) }
        containerView.bringSubviewToFront(viewToPresent)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: [.curveEaseInOut]) {
            viewToPresent.transform = self.isPresenting ? .identity : scaleTransform
            viewToPresent.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        } completion: { _ in
            if !self.isPresenting { self.dismissCompletion?() }
            transitionContext.completeTransition(true)
        }
    }
}
