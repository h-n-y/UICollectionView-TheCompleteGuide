//
//  PrimaryViewController.swift
//  LayoutTransition
//
//  Created by Hans Yelek on 5/19/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class PrimaryViewController: UICollectionViewController {

    private let cellIdentifier = "Cell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        collectionView?.registerClass(UICollectionViewCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
}

// MARK: - UICollectionViewDataSource

extension PrimaryViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 100
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.backgroundColor = UIColor.randomColor()
        return cell
    }
}

// MARK: - UICollectionViewDelegate 

extension PrimaryViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        let viewController = SecondaryViewController(collectionViewLayout: SecondaryLayout())
        viewController.useLayoutToLayoutNavigationTransitions = true
        navigationController?.pushViewController(viewController, animated: true)
    }
}
