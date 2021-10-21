//
//  UIViewExtension.swift
//  VoiceChangeLite
//
//  Created by Linh Nguyen Duc on 25/02/2021.
//

import UIKit

extension UIView {
    func roundView(coners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: coners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
