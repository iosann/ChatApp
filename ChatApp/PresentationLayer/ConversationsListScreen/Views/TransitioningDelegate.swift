//
//  TransitioningDelegate.swift
//  ChatApp
//
//  Created by Anna Belousova on 05.05.2022.
//

import UIKit

extension ConversationsListViewController: UIViewControllerTransitioningDelegate {

    func animationController(forPresented presented: UIViewController,
                             presenting: UIViewController,
                             source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        guard let navigationBarSubviews = self.navigationController?.navigationBar.subviews else { return transition }
        for subview in navigationBarSubviews {
            for view in subview.subviews where view.bounds.width < 50 {
                let frame = CGRect(x: view.frame.origin.x - view.frame.size.width / 2,
                                   y: view.frame.size.height * 1.5,
                                   width: view.frame.size.width,
                                   height: view.frame.size.height)
                transition.originFrame = frame
                transition.isPresenting = true
                view.isHidden = true
            }
        }
        return transition
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
