//
//  CollectionHeaderView.swift
//  Survey
//
//  Created by Hans Yelek on 4/30/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionHeaderView: UICollectionReusableView {
    
    var text: String = "" {
        didSet {
            textLabel.text = text 
        }
    }
    let textLabel: UILabel
    
    override init(frame: CGRect) {
        textLabel = CollectionHeaderView.newTextLabel()
        
        super.init(frame: frame)
        
        self.addSubview(textLabel)
        textLabel.constrainToEdgesOfContainerWithInsets(topBottom: 10, leftRight: 30)
    }
    
    required init?(coder aDecoder: NSCoder) {
        textLabel = CollectionHeaderView.newTextLabel()
        
        super.init(coder: aDecoder)
        
        self.addSubview(textLabel)
        textLabel.constrainToEdgesOfContainerWithInsets(topBottom: 10, leftRight: 30)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        text = ""
    }

    // MARK: Class

    private class func newTextLabel() -> UILabel {
        let textLabel = UILabel()
        textLabel.backgroundColor = UIColor.clearColor()
        textLabel.textColor = UIColor.whiteColor()
        textLabel.font = UIFont.boldSystemFontOfSize(20)
        return textLabel
    }
}
