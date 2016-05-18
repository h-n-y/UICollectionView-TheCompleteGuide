//
//  CollectionViewFlowLayout.swift
//  StackingLayout
//
//  Created by Hans Yelek on 5/14/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class CollectionViewFlowLayout: UICollectionViewFlowLayout {

    private func setupProperties() {
        itemSize = CGSize(width: 200, height: 200)
        sectionInset = UIEdgeInsets(top: 13.0, left: 13.0, bottom: 13.0, right: 13.0)
        minimumInteritemSpacing = 13.0
        minimumLineSpacing = 13.0
    }
    
    override init() {
        super.init()
        setupProperties()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupProperties()
    }    
}
