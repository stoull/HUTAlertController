//
//  HUTAlertDismissAnimation.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

class HUTAlertDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    var interactionController: HUTAlertInteractionController? = nil
    var animationType: HUTAlertTransitionAnimationType = .alphaChange
    
    convenience init(animationType: HUTAlertTransitionAnimationType) {
        self.init()
        self.animationType = animationType
    }
    
    
    convenience init(interactionController: HUTAlertInteractionController?) {
        self.init()
        self.interactionController = interactionController
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.25
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: .from)
        else {
            return
        }
        
        guard let toView = transitionContext.view(forKey: .to),
              let fromView = transitionContext.view(forKey: .from) else {
            return
        }
        
        let duration = transitionDuration(using: transitionContext)
        let containerView = transitionContext.containerView
        
        // Animated the view in the 'fromView' rather than container
        containerView.addSubview(toView)
        containerView.addSubview(fromVC.view)
        
        fromView.alpha = 1.0
        
        UIView.animateKeyframes(withDuration: duration,
                                delay: 0,
                                options: .calculationModeCubic) {
            
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 1.0) {
                fromView.alpha = 0.0
            }
            
        } completion: { isFinished in
            toView.removeFromSuperview()
            fromView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
