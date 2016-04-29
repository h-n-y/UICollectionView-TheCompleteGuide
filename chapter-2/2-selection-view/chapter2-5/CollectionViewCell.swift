//
//  CollectionViewCell.swift
//  chapter2-5
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private let imageView = UIImageView()
    var image: UIImage? = nil {
        didSet {
            imageView.image = image 
        }
    }
    
    override var highlighted: Bool {
        didSet {
            if highlighted {
                imageView.alpha = 0.8
            } else {
                imageView.alpha = 1.0
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        imageView.frame = CGRectInset(self.bounds, 10, 10)
        imageView.contentMode = .ScaleAspectFill
        imageView.clipsToBounds = true 
        self.contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        imageView.frame = CGRectInset(self.bounds, 10, 10)
        self.contentView.addSubview(imageView)
        
        let selectedBackgroundView = UIView(frame: CGRectZero)
        selectedBackgroundView.backgroundColor = UIColor.whiteColor().colorWithAlphaComponent(0.8)
        self.selectedBackgroundView = selectedBackgroundView
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.backgroundColor = UIColor.whiteColor()
        self.image = nil
        
    }
    
}
