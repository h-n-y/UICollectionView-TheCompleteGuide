
import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    // MARK: Instance
    
    var image: UIImage? = nil {
        didSet {
            imageView.image = image
        }
    }
    private let imageView: UIImageView
    
    override init(frame: CGRect) {
        imageView = UIImageView(frame: CGRectZero)
        imageView.backgroundColor = UIColor.blackColor()
        //imageView.contentMode = .ScaleAspectFit
        
        super.init(frame: frame)
        
        self.contentView.addSubview(imageView)
        //imageView.frame = CGRectInset(self.contentView.bounds, 30, 10)
        imageView.constrainToEdgesOfContainerWithInset(10.0)
        
        
        let selectedBackgroundView = CollectionViewCell.newSelectedBackgroundView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageView = CollectionViewCell.newImageView()
        
        super.init(coder: aDecoder)
        
        self.contentView.addSubview(imageView)
        //imageView.frame = CGRectInset(self.contentView.bounds, 30, 10)
        imageView.constrainToEdgesOfContainerWithInset(10.0)
        
        let selectedBackgroundView = CollectionViewCell.newSelectedBackgroundView()
        self.selectedBackgroundView = selectedBackgroundView
        
        self.backgroundColor = UIColor.whiteColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
        self.selected = false
        //imageView.constrainToEdgesOfContainerWithInset(10)
    }
    
    
    func setDisabled(disabled: Bool) {
        self.contentView.alpha = disabled ? 0.5 : 1.0
        self.backgroundColor = disabled ? UIColor.grayColor() : UIColor.whiteColor()
    }
    
    // MARK: Class
    
    private static func newImageView() -> UIImageView {
        let imageView = UIImageView(frame: CGRectZero)
        imageView.backgroundColor = UIColor.blackColor()
        return imageView
    }
    
    private static func newSelectedBackgroundView() -> UIView {
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.orangeColor()
        return selectedBackgroundView
    }
}
