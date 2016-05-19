//
//  CollectionViewHeaderView.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/14/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewHeaderView: UICollectionReusableView {
    
    private let label: UILabel
    var text = "" {
        didSet {
            label.text = text
        }
    }
    
    private(set) static var kind = "Header View"
    
    private class func newLabel() -> UILabel {
        let label = UILabel(frame: CGRectZero)
        label.backgroundColor = UIColor.clearColor()
        label.textAlignment = .Center
        return label
    }
    
    private func setupLabel() {
        //contentView.addSubview(label)
        addSubview(label)
        label.constrainEdgesToContainer()
    }
    
    override init(frame: CGRect) {
        label = CollectionViewHeaderView.newLabel()
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.orangeColor()
        setupLabel()
    }
    
    required init?(coder aDecoder: NSCoder) {
        label = CollectionViewHeaderView.newLabel()
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.orangeColor()
        setupLabel()
    }
}
