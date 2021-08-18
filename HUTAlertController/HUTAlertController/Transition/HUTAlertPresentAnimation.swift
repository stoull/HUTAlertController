//
//  HUTAlertPresentAnimation.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

class HUTAlertPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var animationType: HUTAlertTransitionAnimationType = .alphaChange
    
    convenience init(animationType: HUTAlertTransitionAnimationType) {
        self.init()
        self.animationType = animationType
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.25)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        
        guard let fromVC = transitionContext.viewController(forKey: .from),
              let toView = transitionContext.view(forKey: .to) else {
            transitionContext.completeTransition(true)
            return
        }
        
        // Round corner before take the snapshot
        guard let snapshot = fromVC.view.snapshotView(afterScreenUpdates: true) else {
            return
        }
        
        toView.alpha = 0.0
        containerView.addSubview(snapshot)
        toView.frame = CGRect(origin: .zero, size: UIScreen.main.bounds.size)
        containerView.addSubview(toView)
        
        
        let duration = transitionDuration(using: transitionContext)
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeLinear) {
            
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 1.0) {
                toView.alpha = 1.0
            }
        } completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
