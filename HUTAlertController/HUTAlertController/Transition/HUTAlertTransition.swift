//
//  HUTAlertTransition.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

enum HUTAlertTransitionAnimationType {
    case alphaChange
    case showFromBottom
}

class HUTAlertTransition: NSObject, UIViewControllerTransitioningDelegate {
    var animationType: HUTAlertTransitionAnimationType = .alphaChange
    convenience init(animationType: HUTAlertTransitionAnimationType) {
        self.init()
        self.animationType = animationType
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HUTAlertPresentAnimation(animationType: self.animationType)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HUTAlertDismissAnimation(animationType: self.animationType)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        guard let animator = animator as? HUTAlertDismissAnimation,
              let interactionController = animator.interactionController,
              interactionController.interactionInprogress else {
            return nil
        }
        return interactionController
    }
}
