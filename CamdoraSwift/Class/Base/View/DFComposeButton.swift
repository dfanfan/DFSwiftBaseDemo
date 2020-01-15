//
//  DFComposeButton.swift
//  CamdoraSwift
//
//  Created by user on 11/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import UIKit

class DFComposeButton: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    private let composeBtn:UIButton = UIButton()
    
}


extension DFComposeButton {
    private func setupUI() {
        self.backgroundColor = UIColor.clear
        let width = 60.0
        let plusView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: width))
        self.addSubview(plusView)
        
        let radius = asin((48.0 - width/2) / (width/2.0))
        let startAngle = Double.pi + radius
        let endAngle = Double.pi * 2.0 - radius
        
        let arcPath = UIBezierPath(arcCenter: CGPoint(x: width / 2.0, y: width / 2.0), radius: CGFloat(width / 2.0), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        
        let arcPahtLayer = CAShapeLayer()
        arcPahtLayer.path = arcPath.cgPath
        arcPahtLayer.lineWidth = 0.5
        arcPahtLayer.fillColor = UIColor.white.cgColor
        arcPahtLayer.strokeColor = UIColor.lightGray.cgColor
        plusView.layer.addSublayer(arcPahtLayer)
        
        
        composeBtn.frame = CGRect(x: 0, y: 0, width: width, height: width)
        composeBtn.setImage(UIImage(named:"camdora_home_start"), for: .normal)
        plusView.addSubview(composeBtn)

        
    }
    
    func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControlEvents) {
        composeBtn.addTarget(target, action: action, for: controlEvents)

    }
}
