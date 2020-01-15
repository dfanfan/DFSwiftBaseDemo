//
//  DFRootTabBarController.swift
//  CamdoraSwift
//
//  Created by dff on 2020/1/15.
//  Copyright © 2020 Fanfan. All rights reserved.
//

import UIKit

class DFRootTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        setupTabProperty()
    }
}

extension DFRootTabBarController {
    fileprivate func setupTabProperty() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = colorTheme
    }
    
//    fileprivate func setupComposeButton() {
//        tabBar.addSubview(composeButton)
//        composeButton.snp.makeConstraints { (make) in
//            make.width.height.equalTo(60)
//            make.centerX.equalTo(tabBar)
//            make.top.equalTo(-12)
//        }
//        composeButton.addTarget(self, action: #selector(clickComposeButton), for: UIControlEvents.touchUpInside)
//
//    }
    
    fileprivate func setupChildControllers() {
        
        let jsonPath = getDocDirectorWithString(path: "main.json")
        
        var data = NSData(contentsOfFile: jsonPath)
        
        if data == nil {
            let path = Bundle.main.path(forResource: "main", ofType: "json")
            data = NSData(contentsOfFile: path!)
        }
        
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[String: String]] else {
            return
        }
        
        var arrayM = [UIViewController]()
        for dict in array! {
            arrayM.append(controller(dict: dict))
        }
        viewControllers = arrayM
        
    }
    
    private func controller(dict: [String : String]) -> UIViewController {
        guard let clsName = dict["clsName"], let imageName = dict["imageName"], let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type else {
            return UIViewController()
        }
        let vc = cls.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_pre")
        
        let insets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
        
        vc.tabBarItem.imageInsets = insets
        
//        let nav = DFNavigationController(rootViewController: vc)
        
        return vc
    }
}
