//
//  RootTransitionAnimator.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

enum DFTransitionAnimationType : Int {
    
    case TransitionAnimationPresented = 1
    
    case TransitionAnimationDismiss
    
    case TransitionAnimationPush
    
    case TransitionAnimationPop

}

@objc protocol DFPresentedProtocol {
    
    @objc optional func getView() -> UIView
    
    @objc optional func getStartRect() -> CGRect
    
    @objc optional func getEndRect() -> CGRect

}

@objc protocol DFDismissProtocol {
    
    @objc optional func getView() -> UIView
    
}

class RootTransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var animationType:DFTransitionAnimationType?
    weak var presentDelegate:DFPresentedProtocol?
    weak var dismissDelegate:DFDismissProtocol?
    
    weak var startView:UIView?

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.3
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let animationType = animationType else {
            return
        }
        switch animationType {
        case .TransitionAnimationPresented:
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            guard let toViewController = toVC else {
                return
            }
            transitionContext.containerView.addSubview(toViewController.view)
            guard let presentDelegate = presentDelegate else {
                transitionContext.completeTransition(true)
                return
            }
            startView = presentDelegate.getView!()
            let view = startView?.snapshotView(afterScreenUpdates: false)
            view?.frame = presentDelegate.getStartRect!()
            transitionContext.containerView.backgroundColor = UIColor.clear
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                view?.frame = presentDelegate.getEndRect!()
                toVC?.view.alpha = 1.0
            }, completion: { (finished) in
                self.startView?.isHidden = false
                view?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            
            break
        case .TransitionAnimationDismiss:
            let dismissView = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)?.view
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            guard let toView = toVC?.view, let dismissVi = dismissView else {
                return
            }
            transitionContext.containerView.insertSubview(toView, aboveSubview: dismissVi)
            guard let presentDelegate = presentDelegate, let dismissDelegate = dismissDelegate else {
                transitionContext.completeTransition(true)
                return
            }
            startView?.isHidden = true
            let endView = dismissDelegate.getView!()
            let view = endView.snapshotView(afterScreenUpdates: false)
            guard let tempView = view else {
                transitionContext.completeTransition(true)
                return
            }
            view?.frame = endView.frame
            transitionContext.containerView.insertSubview(tempView, aboveSubview: toView)
            let endRect = presentDelegate.getStartRect!()
            let duration = transitionDuration(using: transitionContext)
            UIView.animate(withDuration: duration, animations: {
                view?.frame = endRect
            }, completion: { (finished) in
                self.startView?.isHidden = false
                view?.removeFromSuperview()
                transitionContext.completeTransition(true)
            })
            break
        case .TransitionAnimationPush:
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            guard let toViewController = toVC, let fromViewController = fromVC else {
                transitionContext.completeTransition(true)
                return
            }
            if fromViewController.view.frame.width != toViewController.view.frame.width {
                var frame = toViewController.view.frame
                frame.size.width = fromViewController.view.frame.width
                frame.size.height = fromViewController.view.frame.height
                toViewController.view.frame = frame
            }
            let containerView = transitionContext.containerView
            containerView .insertSubview(toViewController.view, aboveSubview: fromViewController.view)
            let duration = transitionDuration(using: transitionContext)
            toViewController.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
            fromViewController.view.alpha = 0.5
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.96)
                toViewController.view.transform = CGAffineTransform.identity
            }, completion: { (finished) in
                fromViewController.view.transform = CGAffineTransform.identity
                toViewController.view.transform = CGAffineTransform.identity
                fromViewController.view.alpha = 1.0
                
                transitionContext.completeTransition(true)
            })
            
            break
        case .TransitionAnimationPop:
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            guard let toViewController = toVC, let fromViewController = fromVC else {
                transitionContext.completeTransition(true)
                return
            }
            if fromViewController.view.frame.width != toViewController.view.frame.width {
                var frame = toViewController.view.frame
                frame.size.width = fromViewController.view.frame.width
                frame.size.height = fromViewController.view.frame.height
                toViewController.view.frame = frame
            }
            let containerView = transitionContext.containerView
            containerView.insertSubview(toViewController.view, belowSubview: fromViewController.view)
            let duration = transitionDuration(using: transitionContext)
            toViewController.view.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.96)
            toViewController.view.alpha = 0.5
            
            UIView.animate(withDuration: duration, animations: {
                fromViewController.view.transform = CGAffineTransform.init(translationX: UIScreen.main.bounds.width, y: 0)
                toViewController.view.transform = CGAffineTransform.identity
                toViewController.view.alpha = 1.0
            }, completion: { (finished) in
                fromViewController.view.transform = CGAffineTransform.identity
                toViewController.view.transform = CGAffineTransform.identity
                
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
            break
        
            
        }
        
        
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        animationType = .TransitionAnimationPresented
        return self
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animationType = .TransitionAnimationDismiss
        return self
    }

    
    
}




//TODO:UIViewControllerAnimatedTransitioning
extension RootNavigationTransition {
    
    func aaa() {
        
        
    }
    
}
