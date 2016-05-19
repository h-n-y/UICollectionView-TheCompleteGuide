//
//  DecorationView.swift
//  CircleLayout
//
//  Created by Hans Yelek on 5/13/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class DecorationView: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupGradientMask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupGradientMask()
    }
    
    private func setupGradientMask() {
        
        backgroundColor = UIColor.whiteColor()
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.contentsScale = UIScreen.mainScreen().scale
        gradientLayer.colors = [UIColor.blackColor().CGColor, UIColor.clearColor().CGColor]
        gradientLayer.frame = bounds
        
        layer.mask = gradientLayer
    }
}
