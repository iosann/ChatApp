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
}

class PopAnimator: NSObject, IPopAnimator, UIViewControllerAnimatedTransitioning {
    
    private let duration: TimeInterval = 1
    var isPresenting = true
    var originFrame = CGRect.zero
    var dismissCompletion: (() -> Void)?
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        let profileView = isPresenting ? transitionContext.view(forKey: .to) : transitionContext.view(forKey: .from)
        guard let profileView = profileView else {
            transitionContext.completeTransition(false)
            return
        }
        let initialFrame = isPresenting ? originFrame : profileView.frame
        let finalFrame = isPresenting ? profileView.frame : originFrame
        let xScaleFactor = isPresenting
                            ? initialFrame.width / finalFrame.width
                            : finalFrame.width / initialFrame.width
        let yScaleFactor = isPresenting
                            ? initialFrame.height / finalFrame.height
                            : finalFrame.height / initialFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor, y: yScaleFactor)
        if isPresenting {
            profileView.transform = scaleTransform
            profileView.center = CGPoint(x: initialFrame.midX, y: initialFrame.midY)
            profileView.clipsToBounds = true
        }
        if let toView = transitionContext.view(forKey: .to) { containerView.addSubview(toView) }
        containerView.bringSubviewToFront(profileView)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 3, options: []) {
            profileView.transform = self.isPresenting ? .identity : scaleTransform
            profileView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        } completion: { _ in
            if !self.isPresenting { self.dismissCompletion?() }
            transitionContext.completeTransition(true)
        }
    }
}
