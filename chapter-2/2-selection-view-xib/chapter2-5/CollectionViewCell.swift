//
//  CollectionViewCell.swift
//  chapter2-5
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private var imageView: UIImageView!
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
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
