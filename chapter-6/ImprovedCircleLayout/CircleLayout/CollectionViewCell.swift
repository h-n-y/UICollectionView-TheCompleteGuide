//
//  CollectionViewCell.swift
//  CircleLayout
//
//  Created by Hans Yelek on 5/9/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    private class func newLabel() -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(24)
        
        return label
    }
    
    private let label: UILabel
    var labelString = "" {
        didSet {
            label.text = labelString
        }
    }
    
    override init(frame: CGRect) {
        label = CollectionViewCell.newLabel()
        
        super.init(frame: frame)
        
        //label.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView.addSubview(label)
        label.constrainEdgesToContainer()
        
        contentView.backgroundColor = UIColor.orangeColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = CollectionViewCell.newLabel()
        
        super.init(coder: aDecoder)
        
        contentView.addSubview(label)
        label.constrainEdgesToContainer()
        
        contentView.backgroundColor = UIColor.orangeColor()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        labelString = ""
    }
    
    
}
