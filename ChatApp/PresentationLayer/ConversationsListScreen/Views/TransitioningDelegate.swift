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
        
        guard let navigationBarSubviews = self.navigationController?.navigationBar.subviews else { return transition.self }
        for subview in navigationBarSubviews {
            for view in subview.subviews where view.bounds.width < 50 {
                let frame = CGRect(x: view.frame.maxX - view.frame.width / 2,
                                   y: view.frame.maxY - view.frame.height / 2,
                                   width: view.frame.width,
                                   height: view.frame.height)
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
