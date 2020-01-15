//
//  UIColor+Utility.swift
//  CamdoraSwift
//
//  Created by dff on 2020/1/15.
//  Copyright © 2020 Fanfan. All rights reserved.
//

import Foundation
import UIKit
 

func colorWithHex(hexColor : Int32, alpha : CGFloat = 1.0) -> UIColor {
    let r = CGFloat((hexColor & 0x00FF0000) >> 16) / 255.0
    let g = CGFloat((hexColor & 0x0000FF00) >> 8) / 255.0
    let b = CGFloat(hexColor & 0x000000FF) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

func colorRandon() -> UIColor {
    let r = CGFloat(arc4random() % 255) / 255.0
    let g = CGFloat(arc4random() % 255) / 255.0
    let b = CGFloat(arc4random() % 255) / 255.0
    return UIColor(red: r, green: g, blue: b, alpha: 1.0)
}

