//
//  ViewController.swift
//  chapter2-2
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private class func randomColorArray() -> Array<UIColor> {
        var tempArray: Array<UIColor> = []
        for _ in 0..<100 {
            tempArray.append(ViewController.randomColor())
        }
        return tempArray
    }
    
    private class func randomColor() -> UIColor {
        let red     = Float(arc4random() % 255) / 255.0
        let green   = Float(arc4random() % 255) / 255.0
        let blue    = Float(arc4random() % 255) / 255.0
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
    }
    
    private let cellReuseIdentifier = "Cell"
    private let colorArray: Array<UIColor>
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        colorArray = ViewController.randomColorArray()
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        colorArray = ViewController.randomColorArray()
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.indicatorStyle = .White
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
    }
}

// MARK: UICollectionViewDataSource

extension ViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = colorArray[indexPath.item]
        return cell
    }
}

