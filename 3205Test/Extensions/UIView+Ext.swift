//
//  UIView+Ext.swift
//  3205Test
//
//  Created by Macbook Pro on 30.07.2021.
//

import UIKit

extension UIView {
    func setupShadow(cornerRad: CGFloat, shadowRad: CGFloat, shadowOp: Float, offset: CGSize) {
        self.layer.cornerRadius = cornerRad
        self.layer.shadowOffset = offset
        self.layer.shadowRadius = shadowRad
        self.layer.shadowOpacity = shadowOp
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
