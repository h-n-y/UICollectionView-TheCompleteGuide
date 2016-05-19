import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private let maskingView = UIView() // called `maskView` in original project
    private let imageView = UIImageView()
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    
    private func setupImageView() {
        contentView.addSubview(imageView)
        imageView.clipsToBounds = true
        imageView.centerInContainer()
        imageView.constrainSize(CGRectInset(contentView.bounds, 10, 10).size)
    }
    
    private func setupMaskView() {
        maskingView.backgroundColor = UIColor.blackColor()
        maskingView.alpha = 0.0
        contentView.addSubview(maskingView)
        maskingView.constrainEdgesToContainer()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupImageView()
        setupMaskView()
        
        backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupImageView()
        setupMaskView()
        
        backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        maskingView.alpha = 0.0
        layer.shouldRasterize = false
        
        guard let attributes = layoutAttributes as? CollectionViewLayoutAttributes else { return }
        
        layer.shouldRasterize = attributes.shouldRasterize
        maskingView.alpha = attributes.maskingValue
    }
}