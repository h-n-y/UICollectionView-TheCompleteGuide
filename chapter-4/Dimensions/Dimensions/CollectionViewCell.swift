import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: Instance 
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    private let imageView: UIImageView
    
    var layoutMode: CollectionViewFlowLayoutMode = .AspectFill
    
    override init(frame: CGRect) {
        imageView = CollectionViewCell.newImageView()
        
        
        super.init(frame: frame)
        
        let dimensionSize: Int = CollectionViewFlowLayout.MAX_ITEM_DIMENSION
        contentView.addSubview(imageView)
        imageView.centerInContainer()
        imageView.constrainWidth(CGFloat(dimensionSize))
        imageView.constrainHeight(CGFloat(dimensionSize))
        
        backgroundColor = UIColor.blackColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageView = CollectionViewCell.newImageView()
        
        super.init(coder: aDecoder)
        
        contentView.addSubview(imageView)
        imageView.centerInContainer()
        
        backgroundColor = UIColor.blackColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        guard let attributes = layoutAttributes as? CollectionViewLayoutAttributes else { return }
        
        layoutMode = attributes.layoutMode
        
        setImageViewFrame(animate: true)
    }
    
    func setImageViewFrame(animate animate: Bool) {
        // Start out with the detail image size of the maximum size 
        var imageViewSize: CGSize = bounds.size
        
        if layoutMode == .AspectFit, let image = imageView.image {
            // Determine the size and aspect ratio for the model's image 
            let photoSize: CGSize = image.size
            let aspectRatio: CGFloat = photoSize.width / photoSize.height
            
            if aspectRatio < 1 {
                // The photo is taller than it is wide, so constrain the width
                imageViewSize = CGSize(width: self.bounds.width * aspectRatio, height: self.bounds.height)
            } else if aspectRatio > 1 {
                // The photo is wider than it is tall, so constrain the height
                imageViewSize = CGSize(width: self.bounds.width, height: self.bounds.height / aspectRatio)
            }
        }
        
        // Set the size of the imageView 
        //imageView.bounds = CGRect(x: 0, y: 0, width: imageViewSize.width, height: imageViewSize.height)
        if let heightConstraint = imageView.constraintWithIdentifier("height"), widthConstraint = imageView.constraintWithIdentifier("width") {
            
            // Animate change in constraints.
            // see: http://stackoverflow.com/questions/25649926/trying-to-animate-a-constraint-in-swift
            heightConstraint.constant = imageViewSize.height
            widthConstraint.constant = imageViewSize.width
            if animate {
                UIView.animateWithDuration(0.5, animations: {
                    self.layoutIfNeeded()
                })
            } 
        }
    }
    
    // MARK: Class
    
    private class func newImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }
}
