import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    private static let BackgroundDecoration = "Decoration Identifier"
    
    private static let MaxItemDimension: CGFloat = 200.0
    static let MaxItemSize = CGSize(width: MaxItemDimension, height: MaxItemDimension)
    
    private var insertedSectionSet = Set<Int>()
    
    override init() {
        super.init()
        
        sectionInset = UIEdgeInsets(top: 30, left: 80, bottom: 30, right: 20)
        minimumInteritemSpacing = 20.0
        minimumLineSpacing = 20.0
        itemSize = CollectionViewFlowLayout.MaxItemSize
        headerReferenceSize = CGSize(width: 60, height: 70)
        
        registerClass(DecorationView.self, forDecorationViewOfKind: CollectionViewFlowLayout.BackgroundDecoration)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        sectionInset = UIEdgeInsets(top: 30, left: 80, bottom: 30, right: 20)
        minimumInteritemSpacing = 20.0
        minimumLineSpacing = 20.0
        itemSize = CollectionViewFlowLayout.MaxItemSize
        headerReferenceSize = CGSize(width: 60, height: 70)
        
        registerClass(DecorationView.self, forDecorationViewOfKind: CollectionViewFlowLayout.BackgroundDecoration)
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard var attributesArray: Array<UICollectionViewLayoutAttributes> = super.layoutAttributesForElementsInRect(rect) else { return nil }
        var newAttributesArray = Array<UICollectionViewLayoutAttributes>() // attributes for decoration view
        
        
        for var attributes in attributesArray {
            applyLayoutAttributes(&attributes)
            
            if attributes.representedElementCategory == .SupplementaryView {
                if let newAttributes: UICollectionViewLayoutAttributes = layoutAttributesForDecorationViewOfKind(CollectionViewFlowLayout.BackgroundDecoration, atIndexPath: attributes.indexPath) {
                    newAttributesArray.append(newAttributes)
                }
            }
        }
        
        attributesArray.appendContentsOf(newAttributesArray)
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard var attributes: UICollectionViewLayoutAttributes = super.layoutAttributesForItemAtIndexPath(indexPath) else { return nil }
        
        applyLayoutAttributes(&attributes)
        
        return attributes
    }
    
    override func layoutAttributesForDecorationViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes = UICollectionViewLayoutAttributes(forDecorationViewOfKind: elementKind, withIndexPath: indexPath)
        
        if elementKind == CollectionViewFlowLayout.BackgroundDecoration,
            let numberOfCellsInSection: Int = collectionView?.numberOfItemsInSection(indexPath.section) {
            
            var tallestCellAttributes: UICollectionViewLayoutAttributes? = nil
            
            for i in 0..<numberOfCellsInSection {
                let cellIndexPath = NSIndexPath(forItem: i, inSection: indexPath.section)
                guard let cellAttributes: UICollectionViewLayoutAttributes = layoutAttributesForItemAtIndexPath(cellIndexPath) else { continue }
                
                if tallestCellAttributes == nil || cellAttributes.frame.height > tallestCellAttributes!.frame.height {
                    tallestCellAttributes = cellAttributes
                }
            }

            let decorationViewHeight: CGFloat = tallestCellAttributes!.frame.height + headerReferenceSize.height
            
            layoutAttributes.size = CGSize(width: collectionViewContentSize().width, height: decorationViewHeight)
            layoutAttributes.center = CGPoint(x: collectionViewContentSize().width / 2.0, y: tallestCellAttributes!.center.y)
            
            // Place the decoration view behind all the cells
            layoutAttributes.zIndex = -1
        }
        
        return layoutAttributes
    }
    
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        
        for updateItem in updateItems {
            if updateItem.updateAction == .Insert, let section = updateItem.indexPathAfterUpdate?.section {
                insertedSectionSet.insert(section)
            }
        }
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        
        insertedSectionSet.removeAll()
    }
    
    override func initialLayoutAttributesForAppearingDecorationElementOfKind(elementKind: String, atIndexPath decorationIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        // Returning nil will cause a crossfade 
        
        var layoutAttributes: UICollectionViewLayoutAttributes? = nil
        
        if elementKind == CollectionViewFlowLayout.BackgroundDecoration &&
            insertedSectionSet.contains(decorationIndexPath.section) {
            
            layoutAttributes = layoutAttributesForDecorationViewOfKind(elementKind, atIndexPath: decorationIndexPath)
            guard layoutAttributes != nil else { return nil }
            layoutAttributes!.alpha = 0.0
            layoutAttributes!.transform3D = CATransform3DMakeTranslation(-layoutAttributes!.frame.width, 0, 0)
        }
        
        return layoutAttributes
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        // Returning nil will cause a crossfade
        
        var layoutAttributes: UICollectionViewLayoutAttributes? = nil
        
        if insertedSectionSet.contains(itemIndexPath.section) {
            layoutAttributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
            layoutAttributes?.transform3D = CATransform3DMakeTranslation(collectionViewContentSize().width, 0, 0)
        }
        
        return layoutAttributes
    }
    
    private func applyLayoutAttributes(inout attributes: UICollectionViewLayoutAttributes) {
        guard attributes.representedElementKind == nil else { return }
        guard let collectionView = self.collectionView else { return }
        
        let width: CGFloat = collectionViewContentSize().width
        let leftMargin: CGFloat = sectionInset.left
        let rightMargin: CGFloat = sectionInset.right
        let itemsInSection = collectionView.numberOfItemsInSection(attributes.indexPath.section)
        
        let firstXPosition: CGFloat = ( width - ( leftMargin + rightMargin )) / ( 2 * CGFloat(itemsInSection) )
        let xPosition: CGFloat = firstXPosition + ( 2 * firstXPosition * CGFloat(attributes.indexPath.item) )
        
        attributes.center = CGPoint(x: leftMargin + xPosition, y: attributes.center.y)
        attributes.frame = CGRectIntegral(attributes.frame)
    }
}
