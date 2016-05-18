//
//  CollectionViewLayoutAttributes.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/16/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var shadowOpacity:  CGFloat = 0.0
    var maskingValue:   CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let attributes = super.copyWithZone(zone) as! CollectionViewLayoutAttributes
        attributes.shadowOpacity = shadowOpacity
        attributes.maskingValue = maskingValue
        
        return attributes
    }
}
