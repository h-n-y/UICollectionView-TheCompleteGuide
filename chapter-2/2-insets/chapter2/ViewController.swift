//
//  ViewController.swift
//  chapter2
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private let cellReuseIdentifier = "Cell"
    private let colorArray: Array<UIColor>
    
    required init?(coder aDecoder: NSCoder) {
        
        // setup colorArray
        var tempArray: Array<UIColor> = []
        let numberOfColors = 100
        for _ in 0..<numberOfColors {
            
            let red     = Float(arc4random() % 255) / 255.0
            let green   = Float(arc4random() % 255) / 255.0
            let blue    = Float(arc4random() % 255) / 255.0
            
            tempArray.append(UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0))
        }
        
        colorArray = tempArray
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }

}

// MARK: UICollectionViewDataSource

extension ViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        
        cell.backgroundColor = colorArray[indexPath.item]
        
        return cell
    }
}

