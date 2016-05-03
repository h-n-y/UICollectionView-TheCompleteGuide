//
//  CollectionViewLayoutAttributes.swift
//  CoverFlow

import UIKit

class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var shouldRasterize: Bool = true 
    var maskingValue: CGFloat = 0.0
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let attributes = super.copyWithZone(zone) as! CollectionViewLayoutAttributes
        attributes.shouldRasterize = self.shouldRasterize
        attributes.maskingValue = self.maskingValue
        
        return attributes
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object) &&
            self.shouldRasterize == ( object as! CollectionViewLayoutAttributes ).shouldRasterize &&
            self.maskingValue == (object as! CollectionViewLayoutAttributes ).maskingValue
    }
}
