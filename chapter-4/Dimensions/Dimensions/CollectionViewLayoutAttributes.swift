import UIKit

class CollectionViewLayoutAttributes: UICollectionViewLayoutAttributes {

    var layoutMode: CollectionViewFlowLayoutMode = .AspectFill
    
    override func copyWithZone(zone: NSZone) -> AnyObject {
        let attributes = super.copyWithZone(zone) as! CollectionViewLayoutAttributes
        attributes.layoutMode = self.layoutMode
        return attributes
    }
    
    override func isEqual(object: AnyObject?) -> Bool {
        return super.isEqual(object) && ( layoutMode == (object as! CollectionViewLayoutAttributes).layoutMode )
    }
}
