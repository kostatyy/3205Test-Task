//
//  Colors+Ext.swift
//  3205Test
//
//  Created by Macbook Pro on 31.07.2021.
//

import UIKit

extension UIColor {
    
    static var mainColor = toRGB(red: 0, green: 201, blue: 164, alpha: 1)
    
    static func toRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: alpha)
    }
}
