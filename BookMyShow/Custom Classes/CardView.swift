//
//  CardView.swift
//  BookMyShow
//
//  Created by Neeraj Solanki on 10/10/20.
//  Copyright © 2020 Mr.Solanki. All rights reserved.
//

import UIKit
@IBDesignable class CardView: UIView {
    
    var cornnerRadius : CGFloat = 5
    var shadowOfSetWidth : CGFloat = 0
    var shadowOfSetHeight : CGFloat = 1
    var shadowColour : UIColor = #colorLiteral(red: 0.5741485357, green: 0.5741624236, blue: 0.574154973, alpha: 1)
    var shadowOpacity : CGFloat = 0.6
    
    override func layoutSubviews() {
        layer.cornerRadius = cornnerRadius
        layer.shadowColor = shadowColour.cgColor
        layer.shadowOffset = CGSize(width: shadowOfSetWidth, height: shadowOfSetHeight)
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornnerRadius)
        layer.shadowPath = shadowPath.cgPath
        layer.shadowOpacity = Float(shadowOpacity)
        layer.position = center
        layer.compositingFilter = "multiplyBlendMode"
    }
}
