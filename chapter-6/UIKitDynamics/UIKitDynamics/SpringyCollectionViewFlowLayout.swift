//
//  SpringyCollectionViewFlowLayout.swift
//  UIKitDynamics
//
//  Created by Hans Yelek on 5/19/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class SpringyCollectionViewFlowLayout: UICollectionViewFlowLayout {

    private var dynamicAnimator: UIDynamicAnimator? = nil
    
    private func setDefaultPropertyValues() {
        minimumInteritemSpacing = 10.0
        itemSize = CGSize(width: 44, height: 44)
        sectionInset = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
        
        dynamicAnimator = UIDynamicAnimator(collectionViewLayout: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setDefaultPropertyValues()
    }
    
    override init() {
        super.init()
        setDefaultPropertyValues()
    }
    
    override func prepareLayout() {
        super.prepareLayout()
        guard let collectionView = self.collectionView else { print("WARNING"); return }
        guard dynamicAnimator != nil else { print("WARNING"); return }
        
        let contentSize: CGSize = collectionView.contentSize
        guard let items: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(CGRect(origin: CGPointZero, size: contentSize)) else { print("WARNING"); return }
        
        if dynamicAnimator!.behaviors.isEmpty {
            for layoutAttributes in items {
                let behavior = UIAttachmentBehavior(item: layoutAttributes, attachedToAnchor: layoutAttributes.center)
                behavior.length = 0.0
                behavior.damping = 0.8
                behavior.frequency = 1.0
                
                dynamicAnimator!.addBehavior(behavior)
            }
        }
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let animator = self.dynamicAnimator else { return super.layoutAttributesForElementsInRect(rect) }
        
        return animator.itemsInRect(rect) as? [UICollectionViewLayoutAttributes]
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let animator = self.dynamicAnimator else { return super.layoutAttributesForItemAtIndexPath(indexPath) }
        
        return animator.layoutAttributesForCellAtIndexPath(indexPath)
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        guard let collectionView = self.collectionView else { print("WARNING"); return false }
        guard let animator = self.dynamicAnimator else { print("WARNING"); return false }
        
        let scrollView: UIScrollView = collectionView
        let delta: CGFloat = newBounds.origin.y - scrollView.bounds.origin.y
        
        let touchLocation: CGPoint = collectionView.panGestureRecognizer.locationInView(collectionView)
        
        for behavior in animator.behaviors where behavior is UIAttachmentBehavior {
            
            let yDistanceFromTouch = fabs(touchLocation.y - (behavior as! UIAttachmentBehavior).anchorPoint.y)
            let xDistanceFromTouch = fabs(touchLocation.x - (behavior as! UIAttachmentBehavior).anchorPoint.x)
            let scrollResistance: CGFloat = ( yDistanceFromTouch + xDistanceFromTouch ) / 1500.0
            
            guard let item = (behavior as! UIAttachmentBehavior).items.first as? UICollectionViewLayoutAttributes else { print("WARNING"); return false }
            var center: CGPoint = item.center
            if delta < 0 {
                center.y += max(delta, delta * scrollResistance)
            } else {
                center.y += min(delta, delta * scrollResistance)
            }
            item.center = center
            
            animator.updateItemUsingCurrentState(item)
        }
        return false 
    }
}
