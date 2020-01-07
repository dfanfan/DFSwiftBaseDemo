//
//  DFNavigationController.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

class DFNavigationController: UINavigationController {

    lazy var navTransition = RootNavigationTransition.init(nVC: self)

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.isHidden = true
        
        interactivePopGestureRecognizer?.isEnabled = false
    
        let popRecogizer = UIScreenEdgePanGestureRecognizer.init(target: self, action: #selector(handlePopRecognizer(recognizer:)))
        popRecogizer.edges = .left
        view.addGestureRecognizer(popRecogizer)
        
        // Do any additional setup after loading the view.
    }
    
    @objc func handlePopRecognizer(recognizer: UIScreenEdgePanGestureRecognizer) {
        navTransition.handlePopRecognizer(recognizer: recognizer)
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if childViewControllers.count > 0 {
//            viewController.hidesBottomBarWhenPushed = true
//        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    
 

}
