//
//  CollectionViewCircleLayout.swift
//  CircleLayout
//
//  Created by Hans Yelek on 5/9/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

protocol CollectionViewDelegateCircleLayout {
    
    func rotationAngleForSupplementaryViewInCircleLayout(layout: CollectionViewCircleLayout) -> CGFloat
}

class CollectionViewCircleLayout: UICollectionViewLayout {
    
    private static let itemDimension = 100
    private static let DECORATION_VIEW = "Decoration View"
    
    private var insertedRowSet = Set<Int>()
    private var deletedRowSet  = Set<Int>()
    
    private var cellCount: Int = 12
    private var center = CGPointZero
    private var radius: CGFloat = 0.0
    
    override init() {
        super.init()
        
        registerClass(DecorationView.self, forDecorationViewOfKind: CollectionViewCircleLayout.DECORATION_VIEW)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        registerClass(DecorationView.self, forDecorationViewOfKind: CollectionViewCircleLayout.DECORATION_VIEW)
    }

    override func prepareLayout() {
        super.prepareLayout()
        guard let collectionView = self.collectionView else { return }
        
        let size = collectionView.bounds.size
        
        cellCount = collectionView.numberOfItemsInSection(0)
        center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
        radius = min(size.width, size.height) / 2.5
    }
    
    override func collectionViewContentSize() -> CGSize {
        guard let collectionView = self.collectionView else { return CGSizeZero }
        
        return collectionView.bounds.size
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let dimension = CollectionViewCircleLayout.itemDimension
        let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        attributes.size = CGSize(width: dimension, height: dimension)
        attributes.center = CGPoint(x: center.x + CGFloat(radius) * cos(CGFloat(2 * indexPath.item) * CGFloat(M_PI) / CGFloat(cellCount) - CGFloat(M_PI_2)), y: center.y + radius * sin(CGFloat(2 * indexPath.item) * CGFloat(M_PI) / CGFloat(cellCount) - CGFloat(M_PI_2)))
        attributes.transform3D = CATransform3DMakeRotation(2 * CGFloat(M_PI) * CGFloat(indexPath.item) / CGFloat(cellCount), 0, 0, 1)
        
        return attributes
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var attributes = [UICollectionViewLayoutAttributes]()
        
        for index in 0..<cellCount {
            let indexPath = NSIndexPath(forItem: index, inSection: 0)
            if let attribute = layoutAttributesForItemAtIndexPath(indexPath) {
                attributes.append(attribute)
            }
        }
        
        if CGRectContainsPoint(rect, center) {
            if let attribute = layoutAttributesForDecorationViewOfKind(CollectionViewCircleLayout.DECORATION_VIEW, atIndexPath: NSIndexPath(forItem: 0, inSection: 0)) {
                attributes.append(attribute)
            }
        }
        
        return attributes 
    }
    
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: CollectionViewCircleLayout.DECORATION_VIEW, withIndexPath: indexPath)
        guard elementKind == CollectionViewCircleLayout.DECORATION_VIEW else { return layoutAttributes }
        
        var rotationAngle: CGFloat = 0.0
        if let delegate = collectionView?.delegate as? CollectionViewDelegateCircleLayout {
            rotationAngle = delegate.rotationAngleForSupplementaryViewInCircleLayout(self)
        }
        
        layoutAttributes.size = CGSize(width: 20, height: 200)
        layoutAttributes.center = center
        layoutAttributes.transform3D = CATransform3DMakeRotation(rotationAngle, 0, 0, 1)
        layoutAttributes.zIndex = -1
        
        return layoutAttributes
    }
    
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true 
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for updateItem in updateItems {
            
            switch updateItem.updateAction {
            case .Insert:
                guard let item = updateItem.indexPathAfterUpdate?.item else { continue }
                insertedRowSet.insert(item)
                
            case .Delete:
                guard let item = updateItem.indexPathBeforeUpdate?.item else { continue }
                deletedRowSet.insert(item)
                
            default:
                continue
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertedRowSet.removeAll()
        deletedRowSet.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard insertedRowSet.contains(itemIndexPath.item) else {
            return super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        }
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else {
            return super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
        }
        
        attributes.alpha = 0.0
        attributes.center = center
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard deletedRowSet.contains(itemIndexPath.item) else {
            return super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        }
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else {
            return super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        }
        
        attributes.alpha = 0.0
        attributes.center = center
        attributes.transform3D = CATransform3DConcat(CATransform3DMakeScale(0.1, 0.1, 1.0), CATransform3DMakeRotation(CGFloat(2.0 * M_PI) * CGFloat(itemIndexPath.item) / CGFloat(cellCount + 1), 0, 0, 1))
        
        return attributes
    }
    
    func addItem() {
        guard let collectionView = self.collectionView else { return }
        
        collectionView.performBatchUpdates({
            self.cellCount += 1
            collectionView.insertItemsAtIndexPaths([NSIndexPath(forItem: self.cellCount - 1, inSection: 0)])
            }, completion: nil)
    }
    
    func deleteItem() {
        guard cellCount > 1 else { return }
        guard let collectionView = self.collectionView else { return }
        
        collectionView.performBatchUpdates({
            self.cellCount -= 1
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: self.cellCount, inSection: 0)])
            }, completion: nil)
        
    }
}

