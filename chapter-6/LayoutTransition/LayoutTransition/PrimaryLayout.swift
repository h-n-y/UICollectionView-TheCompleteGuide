//
//  PrimaryLayout.swift
//  LayoutTransition
//
//  Created by Hans Yelek on 5/19/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class PrimaryLayout: UICollectionViewFlowLayout {

    override init() {
        super.init()
        itemSize = CGSize(width: 140, height: 140)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        itemSize = CGSize(width: 140, height: 140)
    }
}
