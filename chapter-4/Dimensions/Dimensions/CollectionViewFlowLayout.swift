import UIKit

@objc enum CollectionViewFlowLayoutMode: Int {
    case AspectFill = 0
    case AspectFit  = 1
}

@objc protocol CollectionViewDelegateFlowLayout: UICollectionViewDelegateFlowLayout {
    
    optional func collectionView(collectionView: UICollectionView, collectionViewLayout layout: UICollectionViewLayout, layoutModeForItemAtIndexPath indexPath: NSIndexPath) -> CollectionViewFlowLayoutMode
    optional func hello()
}

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

    static let MAX_ITEM_DIMENSION: Int = 140
    static let MAX_ITEM_SIZE = CGSize(width: CollectionViewFlowLayout.MAX_ITEM_DIMENSION, height: CollectionViewFlowLayout.MAX_ITEM_DIMENSION)
    
    override class func layoutAttributesClass() -> AnyClass {
        return CollectionViewLayoutAttributes.self
    }

    
    var layoutMode: CollectionViewFlowLayoutMode = .AspectFill {
        didSet {
            invalidateLayout()
        }
    }
    
    private func setupFlowLayoutProperties() {
        itemSize = CollectionViewFlowLayout.MAX_ITEM_SIZE
        sectionInset = UIEdgeInsetsMake(13.0, 13.0, 13.0, 13.0)
        minimumInteritemSpacing = 13.0
        minimumLineSpacing = 13.0        
    }
    
    override init() {
        super.init()
        setupFlowLayoutProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupFlowLayoutProperties()
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attributesArray: [UICollectionViewLayoutAttributes] = super.layoutAttributesForElementsInRect(rect) else { return nil }
        for attributes in attributesArray where attributes is CollectionViewLayoutAttributes {
            applyLayoutAttributes(attributes as! CollectionViewLayoutAttributes)
        }
        return attributesArray
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        guard let attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
            where attributes is CollectionViewLayoutAttributes else { return nil }
        
        applyLayoutAttributes(attributes as! CollectionViewLayoutAttributes)
        return attributes
    }
    
    func applyLayoutAttributes(attributes: CollectionViewLayoutAttributes) {
        // Check for representedElementKind being nil, indicating this is a cell
        // and not a header or decoration view 
        if attributes.representedElementKind == nil {
            // Pass our layout mode onto the layout attributes
            attributes.layoutMode = self.layoutMode
            
            guard let collectionView = self.collectionView else { return }
            if let layoutMode = ( collectionView.delegate as? CollectionViewDelegateFlowLayout )?.collectionView?(collectionView, collectionViewLayout:self, layoutModeForItemAtIndexPath: attributes.indexPath) {
                attributes.layoutMode = layoutMode
            }
        }
    }
}
