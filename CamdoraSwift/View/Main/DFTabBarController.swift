//
//  DFTabBarController.swift
//  CamdoraSwift
//
//  Created by user on 10/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit
import SnapKit

class DFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildControllers()
        
        setupComposeButton()
        
        setupTabProperty()
        
    }

    fileprivate lazy var composeButton: DFComposeButton = DFComposeButton()
}


//TODO:逻辑代码
extension DFTabBarController {
    @objc func clickComposeButton() {
        print("=====")
    }
    
}


extension DFTabBarController {
    fileprivate func setupTabProperty() {
        tabBar.isTranslucent = false
        tabBar.backgroundColor = UIColor.white
        tabBar.tintColor = positiveColor
    }
    
    fileprivate func setupComposeButton() {
        tabBar.addSubview(composeButton)
        composeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
            make.centerX.equalTo(tabBar)
            make.top.equalTo(-12)
        }
        composeButton.addTarget(self, action: #selector(clickComposeButton), for: UIControlEvents.touchUpInside)
        
    }
    
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
        guard let clsName = dict["clsName"], let imageName = dict["imageName"], let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? DFBaseViewController.Type else {
            return UIViewController()
        }
        let vc = cls.init()
        vc.tabBarItem.image = UIImage(named: imageName)
        vc.tabBarItem.selectedImage = UIImage(named: imageName + "_pre")
        var leftOffset:CGFloat = 15
        if clsName == "DFHomeViewController" {
            leftOffset = -15
        }
        let insets = UIEdgeInsets(top: 6, left: leftOffset, bottom: -6, right: -leftOffset)
        
        vc.tabBarItem.imageInsets = insets
        
//        let nav = DFNavigationController(rootViewController: vc)
        
        return vc
    }
}
