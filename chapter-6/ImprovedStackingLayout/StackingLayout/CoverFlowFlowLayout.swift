//
//  CoverFlowFlowLayout.swift
//  CoverFlow
//
//  Created by Hans Yelek on 5/1/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CoverFlowFlowLayout: UICollectionViewFlowLayout {

    override class func layoutAttributesClass() -> AnyClass {
        return CollectionViewLayoutAttributes.self
    }
    
    override init() {
        super.init()
        setDefaultPropertyValues()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaultPropertyValues()
    }
    
    private func setDefaultPropertyValues() {
        scrollDirection = .Horizontal
        itemSize = CGSize(width: 500, height: 500)
        // Get items up close to one another
        minimumLineSpacing = -60
        // Makes sure we only have one row of items in portrait mode
        minimumInteritemSpacing = 200
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        // Very important - need to re-layout the cells when scrolling
        return true
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributesArray = super.layoutAttributesForElementsInRect(rect) else { return nil }
        guard let collectionView = self.collectionView else { return layoutAttributesArray }
        
        // Calculate the rect of the collection view visible to the user 
        let visibleRect = CGRect(x: collectionView.contentOffset.x,
                                 y: collectionView.contentOffset.y,
                                 width: collectionView.bounds.width,
                                 height: collectionView.bounds.height)
        
        for attributes in layoutAttributesArray {
            // Only modify attributes whose frames intersect the visible portion of the collection view
            if CGRectIntersectsRect(attributes.frame, rect) {
                applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
            }
        }
        
        return layoutAttributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
        guard let collectionView = self.collectionView else { return attributes }
        
        // Calculate the rect of the collection view visible to the user
        let visibleRect = CGRect(x: collectionView.contentOffset.x,
                                 y: collectionView.contentOffset.y,
                                 width: collectionView.bounds.width,
                                 height: collectionView.bounds.height)
        
        applyLayoutAttributes(attributes, forVisibleRect: visibleRect)
        
        return attributes
    }
    
    // Forces collection view to center a cell once scrolling has stopped.
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        guard let collectionView = self.collectionView else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        var offsetAdjustment = MAXFLOAT
        let horizontalCenter: CGFloat = proposedContentOffset.x + collectionView.bounds.width / 2.0
        
        // Use the center to find the proposed visible rect.
        let proposedRect = CGRect(x: 0, y: 0, width: collectionView.bounds.width, height: collectionView.bounds.height)
        
        // Get the attributes for the cells in that rect.
        guard let layoutAttributes = layoutAttributesForElementsInRect(proposedRect) else {
            return super.targetContentOffsetForProposedContentOffset(proposedContentOffset, withScrollingVelocity: velocity)
        }
        
        // This loop will find the closest cell to proposed center
        // of the collection view 
        for attributes in layoutAttributes {
            // Skip supplementary views
            if attributes.representedElementCategory != .Cell { continue }
            
            // Determine if this layout attribute's cell is closer than the closest 
            // we have so far.
            let itemHorizontalCenter: CGFloat = attributes.center.x
            if fabs(itemHorizontalCenter - horizontalCenter) < CGFloat(fabs(offsetAdjustment)) {
                offsetAdjustment = Float(itemHorizontalCenter - horizontalCenter)
            }
        }
        
        return CGPoint(x: proposedContentOffset.x + CGFloat(offsetAdjustment), y: proposedContentOffset.y)
    }
    
    // Applies the cover flow effect to the given layout attributes
    private func applyLayoutAttributes(attributes: UICollectionViewLayoutAttributes, forVisibleRect visibleRect: CGRect) {
        // Ignore supplementary views.
        guard attributes.representedElementKind == nil else { return }
        guard let attributes = attributes as? CollectionViewLayoutAttributes else { return }
        
        let ACTIVE_DISTANCE:        CGFloat = 300.0
        let TRANSLATE_DISTANCE:     CGFloat = 200.0
        let ZOOM_FACTOR:            CGFloat = 0.3
        let FLOW_OFFSET:            CGFloat = -17.0
        let INACTIVE_GRAY_VALUE:    CGFloat = 0.6
        
        // Calculate the distance from the center of the visible rect to the center
        // of the attributes. Then normalize the distance so we can compare them all.
        // This way, all items further away than the active get the same transform.
        let distanceFromVisibleRectToItem: CGFloat = CGRectGetMidX(visibleRect) - attributes.center.x
        let normalizedDistance: CGFloat = distanceFromVisibleRectToItem / ACTIVE_DISTANCE
        
        let isLeft = distanceFromVisibleRectToItem > 0
        
        // Default values
        var transform = CATransform3DIdentity
        var maskAlpha: CGFloat = 0.0
        
        if fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE {
            // We're close enough to apply the transform in relation to 
            // how far away from the center we are
            transform = CATransform3DTranslate(CATransform3DIdentity,
                                               (isLeft ? -FLOW_OFFSET: FLOW_OFFSET) * abs(distanceFromVisibleRectToItem / TRANSLATE_DISTANCE ),
                                               0,
                                               (1 - fabs(normalizedDistance)) * 40_000.0 + (isLeft ? 200.0 : 0.0))
            
            // Set the perspective of the transform
            transform.m34 = -1.0 / (4.6777 * itemSize.width)
            
            
            
            // Set the rotation of the transform
            transform = CATransform3DRotate(transform,
                                            (isLeft ? 1 : -1) * fabs(normalizedDistance) * CGFloat(45).radians(),
                                            0,
                                            1,
                                            0)
            
            // Set the zoom factor
            let zoom: CGFloat = 1 + ZOOM_FACTOR * ( 1 - abs(normalizedDistance) )
            transform = CATransform3DScale(transform, zoom, zoom, 1)
            
            attributes.zIndex = 1
            
            let ratioToCenter = ( ACTIVE_DISTANCE - fabs(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE
            // Interpolate between 0.0 and INACTIVE_GRAY_VALUE
            maskAlpha = INACTIVE_GRAY_VALUE + ratioToCenter * (-INACTIVE_GRAY_VALUE)
            
        } else {
            // We're too far away; just apply a standard perpective transform
            transform.m34 = -1 / ( 4.6777 * itemSize.width )
            transform = CATransform3DTranslate(transform, isLeft ? -FLOW_OFFSET : FLOW_OFFSET, 0, 0)
            transform = CATransform3DRotate(transform,
                                            ( isLeft ? 1 : -1 ) * CGFloat(45).radians(),
                                            0,
                                            1,
                                            0)
            
            attributes.zIndex = 0
            
            maskAlpha = INACTIVE_GRAY_VALUE
        }
        
        attributes.transform3D = transform
        
        // Rasterize the cells for smoother edges
        //attributes.shouldRasterize = true
        attributes.maskingValue = maskAlpha
    }
}

extension CGFloat {
    
    /// Assumes that `self`'s current value is in terms of *degrees* and returns
    /// the *radian* equivalent.
    func radians() -> CGFloat {
        return self * CGFloat(M_PI / 180.0)
    }
}
