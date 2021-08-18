//
//  HUTAlertInteractionController.swift
//  HUTAlertController
//
//  Created by Hut on 2021/8/18.
//

import UIKit

class HUTAlertInteractionController: UIPercentDrivenInteractiveTransition {
    var interactionSceenEdge: UIRectEdge = .right
    var interactionInprogress = false
    
    private var shouldCompleteTransition = false
    private weak var viewController: UIViewController!
    
    @objc public init(viewController: UIViewController, interactionSceenEdge: UIRectEdge) {
        super.init()
        self.viewController = viewController
        self.interactionSceenEdge = interactionSceenEdge
        
        prepareGestureRecognizer(in: viewController.view)
    }

    private func prepareGestureRecognizer(in view: UIView) {
        let gesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        gesture.edges = interactionSceenEdge
        view.addGestureRecognizer(gesture)
    }
    
    @objc func handleGesture(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: gestureRecognizer.view?.superview)
        var progress = abs(translation.x) / 200
        progress = CGFloat(fmin(fmax(Float(progress), 0.0), 1.0))
        switch gestureRecognizer.state {
        case .began:
            interactionInprogress = true
            viewController.dismiss(animated: true, completion: nil)
        case .changed:
            shouldCompleteTransition = progress > 0.5
            update(progress)
        case .cancelled:
            interactionInprogress = false
        case .ended:
            interactionInprogress = false
            if shouldCompleteTransition {
                finish()
            } else {
                cancel()
            }
        default:
            break
        }
    }
}
