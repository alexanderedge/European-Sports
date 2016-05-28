//
//  UIColor+Eurosport.swift
//  EurosportPlayer
//
//  Created by Alexander Edge on 28/05/2016.
//  Copyright © 2016 Alexander Edge Ltd. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(integer red: UInt8, green: UInt8, blue: UInt8, alpha: UInt8) {
        self.init(red : CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: CGFloat(alpha) / 255)
    }
    

    public convenience init(hex : UInt32) {
        let red : UInt8 = (UInt8)((hex & 0xff0000) >> 16);
        let green : UInt8 = (UInt8)((hex & 0x00ff00) >> 8);
        let blue : UInt8 = (UInt8)(hex & 0x0000ff);
        self.init(integer: red, green: green, blue : blue, alpha : 255)
    }
    
}

struct Theme {
    
    struct Colours {
        
        static let Red = UIColor(hex: 0xde0038)
        static let BackgroundColour = UIColor(hex: 0x0)
    }
    
    struct Fonts {
    
        internal static func font(ofSize size: CGFloat) -> UIFont {
            return UIFont.systemFontOfSize(size)
        }
        
        internal static func boldFont(ofSize size: CGFloat) -> UIFont {
            return UIFont.boldSystemFontOfSize(size)
        }
        
    }
    
}