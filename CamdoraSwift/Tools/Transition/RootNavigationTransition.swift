//
//  RootNavigationTransition.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

class RootNavigationTransition: NSObject, UINavigationControllerDelegate {
    var interativeTransition:UIPercentDrivenInteractiveTransition?
    
    private weak var navVC: UINavigationController? = nil
    
    init(nVC: UINavigationController) {
        super.init()
        navVC = nVC
        navVC?.delegate = self
    }
    
    @objc public func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        var progress = recognizer.translation(in: recognizer.view).x / (recognizer.view?.bounds.width)!
        progress = min(0.9, max(0.0, progress))
        
        if recognizer.state == .began {
            interativeTransition = UIPercentDrivenInteractiveTransition()
            navVC?.popViewController(animated: true)
        } else if recognizer.state == .changed {
            interativeTransition?.update(progress)
        } else {
            if progress > 0.5 {
                interativeTransition?.finish()
            } else {
                interativeTransition?.cancel()
            }
            
            interativeTransition = nil
        }
    }

    
}

//TODO: UINavigationControllerDelegate
extension RootNavigationTransition {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        if operation == .pop {
            let transitionAnimator = RootTransitionAnimator.init()
            transitionAnimator.animationType = DFTransitionAnimationType.TransitionAnimationPop
            return transitionAnimator
        } else if (operation == .push) {
            let transitionAnimator = RootTransitionAnimator.init()
            transitionAnimator.animationType = DFTransitionAnimationType.TransitionAnimationPush
            return transitionAnimator
        }
        
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if animationController.isKind(of: RootTransitionAnimator.self) {
            return interativeTransition
        }
        return nil
        
    }
}

extension RootNavigationTransition {
    }
