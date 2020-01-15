//
//  DFRootNavigationController.swift
//  CamdoraSwift
//
//  Created by dff on 2020/1/15.
//  Copyright © 2020 Fanfan. All rights reserved.
//

import UIKit

class DFRootNavigationController: UINavigationController {

    //自定义转场动画
//    lazy var navTransition = RootNavigationTransition.init(nVC: self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationBar.isHidden = true
        
        if self.responds(to: #selector(getter: interactivePopGestureRecognizer)) {
            interactivePopGestureRecognizer?.delegate = self
        }
        
        
//        interactivePopGestureRecognizer?.isEnabled = false
//
//        let popRecogizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(handlePopRecognizer(recognizer:)))
//        popRecogizer.edges = .left
//        view.addGestureRecognizer(popRecogizer)

    }
    
//    @objc func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
//        navTransition.handlePopRecognizer(recognizer: recognizer)
//    }
}

// TODO:UIGestureRecognizerDelegate
extension DFRootNavigationController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return childViewControllers.count != 1
    }
}


// TODO:override
extension DFRootNavigationController {
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
        }
        super .pushViewController(viewController, animated: animated)
    }
    
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if let visibleVC = visibleViewController {
            return visibleVC.supportedInterfaceOrientations
        }
        return UIInterfaceOrientationMask.portrait
    }
    
    
}





