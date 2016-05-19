//
//  CollectionViewFlowLayout.swift
//  CircleLayout
//
//  Created by Hans Yelek on 5/9/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private var insertedRowSet  = Set<Int>()
    private var deletedRowSet   = Set<Int>()
    
    private var center = CGPointZero
    private var cellCount: Int = 12
    
    private func setupLayoutProperties() {
        itemSize = CGSize(width: 200, height: 200)
        sectionInset = UIEdgeInsets(top: 13.0, left: 13.0, bottom: 13.0, right: 13.0)
        minimumInteritemSpacing = 13.0
        minimumLineSpacing = 13.0
        
        guard let collectionView = self.collectionView else { return }
        
        let size = collectionView.bounds.size
        center = CGPoint(x: size.width / 2.0, y: size.height / 2.0)
    }

    override init() {
        super.init()
        setupLayoutProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayoutProperties()
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
        guard insertedRowSet.contains(itemIndexPath.item) else { return nil }
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { return nil }
        
        attributes.alpha = 0.0
        attributes.center = center
        
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard deletedRowSet.contains(itemIndexPath.item) else { return nil }
        guard let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath) else { return nil }
        
        attributes.alpha = 0.0
        attributes.center = center
        attributes.transform3D = CATransform3DConcat(CATransform3DMakeRotation(CGFloat(2 * M_PI) * CGFloat(itemIndexPath.item) / CGFloat(cellCount + 1), 0, 0, 1), CATransform3DMakeScale(0.1, 0.1, 1.0))
        
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
