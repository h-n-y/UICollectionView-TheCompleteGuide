
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

// MARK: - UIView Extension ( Constraints )

extension UIView {
    
    /// Constrains `self`'s edges to its superview's edges.
    func constrainToEdgesOfContainer() {
        self.constrainToEdgesOfContainerWithInset(0.0)
    }
    
    /// Constrains `self` such that its edges are inset from its `superview`'s edges by `inset`.
    func constrainToEdgesOfContainerWithInset(inset: CGFloat) {        
        self.constrainToEdgesOfContainerWithInsets(topBottom: inset, leftRight: inset)
    }
    
    func constrainToEdgesOfContainerWithInsets(topBottom y: CGFloat, leftRight x: CGFloat) {
        guard let superview = self.superview else { print("View does not have a superview."); return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        self.topAnchor.constraintEqualToAnchor(superview.topAnchor, constant: y).active = true
        self.bottomAnchor.constraintEqualToAnchor(superview.bottomAnchor, constant: -y).active = true
        self.leftAnchor.constraintEqualToAnchor(superview.leftAnchor, constant: x).active = true
        self.rightAnchor.constraintEqualToAnchor(superview.rightAnchor, constant: -x).active = true 
    }
}
