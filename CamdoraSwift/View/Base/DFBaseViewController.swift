//
//  DFBaseViewController.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

class DFBaseViewController: UIViewController {

    lazy var navView:UIView? = nil
    var bodyView:UIView? = nil
    var leftBtn:UIButton? {
        willSet {
            if let left = leftBtn {
                left.removeFromSuperview()
            }
            
        }
        didSet {
            guard let leftBtn = leftBtn else {
                return
            }
            navView?.addSubview(leftBtn)
            var tempConstraints: [NSLayoutConstraint] = Array()
            tempConstraints.append(constant(offset: 0, attribute: .left, firstView: leftBtn))
            tempConstraints.append(constant(offset: 0, attribute: .bottom, firstView: leftBtn))
            tempConstraints.append(constant(offset: ButtonWidth, attribute: .width, firstView: leftBtn, secondView: nil))
            tempConstraints.append(constant(offset: ButtonWidth, attribute: .height, firstView: leftBtn, secondView: nil))
            navView?.addConstraints(tempConstraints)
        }
        
    }

    
    private var titleButton:UIButton? = nil
    private var lineView:UIView? = nil
    private var buttons:[UIButton]? = nil

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = bgColor
        
        self.automaticallyAdjustsScrollViewInsets = false

        if hideNavView() {
            return
        }

        initNavView()
        
    }
    
    func initNavView() {
        //导航栏
        let nav = UIView()
        view.addSubview(nav)
        navView = nav
        //约束数组
        var tempConstraints: [NSLayoutConstraint] = Array()
        tempConstraints.append(constant(offset: 0, attribute: .left, firstView: nav))
        tempConstraints.append(constant(offset: 0, attribute: .right, firstView: nav))
        tempConstraints.append(constant(offset: 0, attribute: .top, firstView: nav))
        tempConstraints.append(constant(offset: NavigationHeight, attribute: .height, firstView: nav, secondView: nil))
        view.addConstraints(tempConstraints)
        
        //状态栏
        let statusView = UIView()
        nav.addSubview(statusView)
        
        tempConstraints.removeAll()
        tempConstraints.append(constant(offset: 0, attribute: .left, firstView: statusView))
        tempConstraints.append(constant(offset: 0, attribute: .right, firstView: statusView))
        tempConstraints.append(constant(offset: 0, attribute: .top, firstView: statusView))
        tempConstraints.append(constant(offset: 20, attribute: .height, firstView: statusView, secondView: nil))
        nav.addConstraints(tempConstraints)
        
        //bottom line
        let lineView = UIView()
        lineView.backgroundColor = positiveColor
        nav.addSubview(lineView)
        
        tempConstraints.removeAll()
        tempConstraints.append(constant(offset: 0, attribute: .left, firstView: lineView))
        tempConstraints.append(constant(offset: 0, attribute: .right, firstView: lineView))
        tempConstraints.append(constant(offset: 0, attribute: .bottom, firstView: lineView))
        tempConstraints.append(constant(offset: 0.5, attribute: .height, firstView: lineView, secondView: nil))
        nav.addConstraints(tempConstraints)
        
        //左边按钮
        let leftBtn = UIButton()
        leftBtn.backgroundColor = UIColor.red
        nav.addSubview(leftBtn)
        leftBtn.addTarget(self, action: #selector(navBack), for: .touchUpInside)
        self.leftBtn = leftBtn
        
        //标题view
        let titleBtn = UIButton()
        titleBtn.isEnabled = false
        nav.addSubview(titleBtn)
        titleButton = titleBtn
        
        tempConstraints.removeAll()
        tempConstraints.append(constant(offset: 50, attribute: .left, firstView: titleBtn))
        tempConstraints.append(constant(offset: -50, attribute: .right, firstView: titleBtn))
        tempConstraints.append(constant(offset: 0, attribute: .bottom, firstView: titleBtn))
        tempConstraints.append(constant(offset: 0, firstAttribute: .top, firstView: titleBtn, secondAttribute: .bottom, secondView: statusView))
        nav.addConstraints(tempConstraints)
        
    }

    /// 子类可以重写该方法来隐藏navView
    func hideNavView() -> Bool
    {
        return false;
    }
    
    @objc func navBack() {
        guard let count = navigationController?.viewControllers.count else {
            dismiss(animated: true, completion: nil)
            return
        }
        if count > 1 {
            navigationController?.popViewController(animated: true)
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    deinit {
        let name: AnyClass? = object_getClass(self)
        if let name = name {
            print("deinit " + NSStringFromClass(name))
        }
    }
    
}

extension DFBaseViewController {
    //TODO:外部调用方法
    
    /**功能：设置导航栏标题
     * @param title 标题
     * return void
     */
    func setTitle(title: String?, color: UIColor = UIColor.black) {
        guard let titleButton = titleButton else {
            return
        }
        titleButton.setTitle(title, for: .disabled)
        titleButton.setTitleColor(color, for: .disabled)
    }
    
    /**功能：可以设置标题为图片
     * @param image 标题图片
     * return void
     */
    func setTitleImage(image: UIImage?) {
        guard let titleButton = titleButton else {
            return
        }
        titleButton.setImage(image, for: .disabled)
    }
    
    /**功能：可以设置标题为图片
     * @param hiden 标题图片
     * return void
     */
    func setLineHiden(hiden: Bool) {
        guard let lineView = lineView else {
            return
        }
        lineView.isHidden = hiden
    }
    
    /**功能：设置右侧按钮
     * @param buttons
     * return void
     */
    //- (void)setRightButtons:(NSArray *)buttons;
    func setRightButtons(buttons: [UIButton]?) {
        
        if let rightButtons = self.buttons {
            for button in rightButtons {
                button.removeFromSuperview()
            }
        }
        guard let buttons = buttons else {
            self.buttons = nil
            return
        }
        var i:CGFloat = 0
        for button in buttons {
            navView?.addSubview(button)
            var tempConstraints: [NSLayoutConstraint] = Array()
            tempConstraints.append(constant(offset: -i * ButtonWidth, attribute: .right, firstView: button))
            tempConstraints.append(constant(offset: 0, attribute: .bottom, firstView: button))
            tempConstraints.append(constant(offset: ButtonWidth, attribute: .width, firstView: button, secondView: nil))
            tempConstraints.append(constant(offset: ButtonWidth, attribute: .height, firstView: button, secondView: nil))
            navView?.addConstraints(tempConstraints)
            
            i += 1.0
        }
        
        self.buttons = buttons
    }
}


extension DFBaseViewController {
    func constant(offset: CGFloat, attribute: NSLayoutAttribute, firstView: UIView, secondView: UIView?) -> NSLayoutConstraint {
        
        firstView.translatesAutoresizingMaskIntoConstraints = false
        
        return NSLayoutConstraint.init(item: firstView, attribute: attribute, relatedBy: .equal, toItem: secondView, attribute: attribute, multiplier: 1.0, constant: offset)
    }
    
    func constant(offset: CGFloat, firstAttribute: NSLayoutAttribute, firstView: UIView, secondAttribute: NSLayoutAttribute, secondView: UIView?) -> NSLayoutConstraint {
        
        return NSLayoutConstraint.init(item: firstView, attribute: firstAttribute, relatedBy: .equal, toItem: secondView, attribute: secondAttribute, multiplier: 1.0, constant: offset)
    }
    
    func constant(offset: CGFloat, attribute: NSLayoutAttribute, firstView: UIView) -> NSLayoutConstraint {
        
        let secondView = firstView.superview
        
        return constant(offset: offset, attribute: attribute, firstView: firstView, secondView: secondView)
    }
}







