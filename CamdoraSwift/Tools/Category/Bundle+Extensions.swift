//
//  Bundle+Extensions.swift
//  CamdoraSwift
//
//  Created by user on 10/10/17.
//  Copyright © 2017年 Fanfan. All rights reserved.
//

import Foundation

extension Bundle {
    var namespace: String {
        return infoDictionary?["CFBundleName"] as? String ?? ""
    }
}

