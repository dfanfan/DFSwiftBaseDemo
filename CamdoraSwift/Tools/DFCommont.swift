//
//  DFCommont.swift
//  CamdoraSwift
//
//  Created by user on 10/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import Foundation
import UIKit


func getDocDirectorWithString (path: String) -> String {
    let docDirector = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    let filePath = docDirector + path
    
    return filePath
}


let ButtonWidth: CGFloat = 44.0
let NavigationHeight: CGFloat = 64.0

let positiveColor = UIColor(red: 254.0/255.0, green: 187.0/255.0, blue: 1.0/255.0, alpha: 1.0)
let bgColor = UIColor(red: 242.0/255.0, green: 242.0/255.0, blue: 242.0/255.0, alpha: 1.0)
