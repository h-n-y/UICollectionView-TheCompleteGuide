//
//  CollectionViewController.swift
//  UIKitDynamics
//
//  Created by Hans Yelek on 5/19/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

private let cellIdentifier = "Cell"

class CollectionViewController: UICollectionViewController {
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionViewLayout.invalidateLayout()
    }
}

// MARK: - UICollectionViewDataSource

extension CollectionViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 120 * 3
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.orangeColor()
        return cell
    }
}
