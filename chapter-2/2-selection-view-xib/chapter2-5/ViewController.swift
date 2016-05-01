//
//  ViewController.swift
//  chapter2-5
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    // MARK: Instance Members
    
    private let imageArray: Array<UIImage>
    private let colorArray: Array<UIColor>
    
    override init(collectionViewLayout layout: UICollectionViewLayout) {
        imageArray = ViewController.imagesArray()
        colorArray = ViewController.colorsArray()
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        imageArray = ViewController.imagesArray()
        colorArray = ViewController.colorsArray()
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView?.allowsMultipleSelection = true 
    }
    
    // MARK: Class Members
    
    private static let CellReuseIdentifier = "Cell"
    
    private class func imagesArray() -> Array<UIImage> {
        var imageArray = Array<UIImage>()
        for i in 0..<12 {
            let imageName = "\(i).jpg"
            guard let image = UIImage(named: imageName) else { continue }
            imageArray.append(image)
        }
        return imageArray
    }
    
    private class func colorsArray() -> Array<UIColor> {
        var colorArray = Array<UIColor>()
        for _ in 0..<10 {
            colorArray.append(ViewController.randomColor())
        }
        return colorArray
    }
    
    private class func randomColor() -> UIColor {
        let red = Float(arc4random() % 255) / 255.0
        let green = Float(arc4random() % 255) / 255.0
        let blue = Float(arc4random() % 255) / 255.0
        return UIColor(colorLiteralRed: red, green: green, blue: blue, alpha: 1.0)
    }
}

// MARK: - UICollectionViewDataSource

extension ViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return colorArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.CellReuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.image = imageArray[indexPath.item]
        cell.backgroundColor = colorArray[indexPath.section]
        return cell 
    }
}

