//
//  DFIphoneType.swift
//  CamdoraSwift
//
//  Created by dff on 2020/1/15.
//  Copyright © 2020 Fanfan. All rights reserved.
//
import UIKit

public enum DFIphoneType : Int {

    case phone4

    case phone5
    
    case phone6

    case phonePlus
    
    case phoneX
    
    case phoneUnknow
    
    static var phoneType : DFIphoneType {
        let height = UIScreen.main.bounds.size.height
        if height == 480 {
            return .phone4
        }
        if height == 568 {
            return .phone5
        }
        if height == 667 {
            return .phone6
        }
        if height == 736 {
            return .phonePlus
        }
        if height == 812 {
            return .phoneX
        }
        if height == 896 {
            return .phoneX
        }
        
        return .phoneUnknow
    }
    
}
