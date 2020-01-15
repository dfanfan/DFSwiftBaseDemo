//
//  DFMacros.swift
//  CamdoraSwift
//
//  Created by dff on 2020/1/15.
//  Copyright © 2020 Fanfan. All rights reserved.
//

import UIKit


func getDocDirectorWithString (path: String) -> String {
    let docDirector = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath = docDirector + path
    
    return filePath
}

let kScreenWidth = UIScreen.main.bounds.width
let kScreenHeight = UIScreen.main.bounds.height

let kStatusHeight = UIApplication.shared.statusBarFrame.height
let kNavHeight = 44 + kStatusHeight
let kSafeHeight : CGFloat = DFIphoneType.phoneType == DFIphoneType.phoneX ? 34 : 0
let kNavButtonWidth : CGFloat = 44
