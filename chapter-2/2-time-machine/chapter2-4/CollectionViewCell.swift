//
//  CollectionViewCell.swift
//  chapter2-4
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    
    var text: String = "" {
        didSet {
            textLabel.text = text 
        }
    }
    var textLabel: UILabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        textLabel = UILabel(frame: bounds)
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.boldSystemFontOfSize(20)
        
        backgroundColor = UIColor.whiteColor()
        contentView.addSubview(textLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        backgroundColor = UIColor.whiteColor()
        
        textLabel = UILabel(frame: self.bounds)
        textLabel.textAlignment = .Center
        textLabel.font = UIFont.boldSystemFontOfSize(20)
        contentView.addSubview(textLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        text = ""
    }
}
