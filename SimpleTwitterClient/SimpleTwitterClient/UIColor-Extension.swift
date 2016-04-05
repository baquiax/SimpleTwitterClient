//
//  UIColor-Extension.swift
//  SimpleTwitterClient
//
//  Created by Alexander Baquiax on 4/5/16.
//  Copyright © 2016 Alexander Baquiax. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int) {
        
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
        
    }
    
}

extension CGColor {
    
    class func colorWithHex(hex: Int) -> CGColorRef {
        
        return UIColor(hex: hex).CGColor
        
    }
    
}