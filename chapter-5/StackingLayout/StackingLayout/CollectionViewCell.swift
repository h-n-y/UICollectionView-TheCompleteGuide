//
//  CollectionViewCell.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/14/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private var contentMask = UIView(frame: CGRectZero)
    private var imageView = UIImageView(frame: CGRectZero)
    var image: UIImage? {
        didSet {
            imageView.image = image 
        }
    }
    
    private func setupContentMask() {
        contentMask.backgroundColor = UIColor.blackColor()
        contentMask.alpha = 0.0
        
        contentView.addSubview(contentMask)
        contentMask.constrainEdgesToContainer()
    }
    
    private func setupImageView() {
        imageView.clipsToBounds = true
        imageView.contentMode = .ScaleAspectFill
        contentView.addSubview(imageView)
        imageView.insetFromContainerEdges(10.0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        setupImageView()
        setupContentMask()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.whiteColor()
        
        setupImageView()
        setupContentMask()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        image = nil
    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        
        layer.shouldRasterize = true
        layer.shadowColor = UIColor.blackColor().CGColor
        layer.shadowOffset = CGSize(width: 0, height: 3)
        contentMask.alpha = 0.0
        
        guard let attributes = layoutAttributes as? CollectionViewLayoutAttributes else { return }
        
        layer.shadowOpacity = Float(attributes.shadowOpacity)
        contentMask.alpha = attributes.maskingValue
    }
}
