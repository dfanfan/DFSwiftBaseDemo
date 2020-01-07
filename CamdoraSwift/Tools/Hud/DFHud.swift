//
//  DFHud.swift
//  CamdoraSwift
//
//  Created by user on 27/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit
import MBProgressHUD

let hudShowTime = 1.5

class DFHud {
    static var hud : MBProgressHUD? = nil
    //FIXME:自定义view显示
    private class func createHud(view : UIView?, isMask : Bool = false) -> MBProgressHUD? {
        var superView : UIView? = view
        if superView == nil {
            superView = UIApplication.shared.keyWindow
        }
        if let superView = superView {
            
            let tempHud = hud ?? MBProgressHUD.init(view: superView)
            superView.addSubview(tempHud)
            tempHud.animationType = .zoom
            if isMask {
                tempHud.backgroundView.color = UIColor.init(white: 0.0, alpha: 0.4)
            } else {
                tempHud.backgroundView.color = UIColor.clear
            }
            tempHud.removeFromSuperViewOnHide = true
            tempHud.show(animated: true)
            return tempHud
        }
        return nil
    }
    
    //FIXME:自定义view显示
    private class func showHudHint (hint : String?, icon : String?, view : UIView?, completeBlock : (()->(Void))?) {
        let tempHud = self.createHud(view: view, isMask: false)
        tempHud?.label.text = hint
        tempHud?.label.numberOfLines = 0
        
        if let icon = icon {
            tempHud?.customView = UIImageView.init(image: UIImage.init(named: icon))
        }
        tempHud?.mode = .customView
        
        DispatchQueue.main.asyncAfter(deadline: .now() + hudShowTime) {
            tempHud?.hide(animated: true)
            
            guard let completeBlock = completeBlock else {
                return
            }
            completeBlock()
        }
        
    }
}

extension DFHud {
    //TODO:加载提示框
    class func showHudInView (view : UIView?, isMask : Bool = false) {
        let tempHud = self.createHud(view: view, isMask: isMask)
        tempHud?.mode = .indeterminate
        tempHud?.label.text = nil
        hud = tempHud
    }
    
    //TODO:提示文字
    class func showHudHint (hint : String?, view : UIView?, isMask : Bool = false) {
        let tempHud = self.createHud(view: view, isMask: isMask)
        tempHud?.mode = .text
        tempHud?.detailsLabel.font = UIFont.systemFont(ofSize: 16.0)
        tempHud?.detailsLabel.text = hint
        
        tempHud?.hide(animated: true, afterDelay: hudShowTime)
    }
    //TODO:成功后提示
    class func showSuccesshHint (hint : String?, view : UIView?, completeBlock : (()->(Void))?) {
        self.showHudHint(hint: hint, icon: nil, view: view, completeBlock: completeBlock)
    }
    //TODO:失败后提示
    class func showFailedHint (hint : String?, view : UIView?, completeBlock : (()->(Void))?) {
        self.showHudHint(hint: hint, icon: nil, view: view, completeBlock: nil)
    }
    
    //TODO:隐藏提示框
    class func hideHud () {
        guard let tempHud = hud else {
            return
        }
        tempHud.hide(animated: false)
        hud = nil
    }
}

