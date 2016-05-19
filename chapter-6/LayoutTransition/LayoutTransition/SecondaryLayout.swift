//
//  SecondaryLayout.swift
//  LayoutTransition
//
//  Created by Hans Yelek on 5/19/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class SecondaryLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        itemSize = CGSize(width: 200, height: 200)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        itemSize = CGSize(width: 200, height: 200)
    }
}
