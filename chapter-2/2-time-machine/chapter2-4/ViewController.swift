//
//  ViewController.swift
//  chapter2-4
//
//  Created by Hans Yelek on 4/25/16.
//  Copyright © 2016 Hans Yelek. All rights reserved.
//

import UIKit

class ViewController: UICollectionViewController {
    
    private static let CellReuseIdentifier = "Cell"
    
    private var datesArray: Array<NSDate> = []
    private let dateFormatter = NSDateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        dateFormatter.setLocalizedDateFormatFromTemplate("h:mm:ss a")
        
        guard let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        flowLayout.minimumInteritemSpacing = 40.0
        flowLayout.minimumLineSpacing = 40.0
        flowLayout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        flowLayout.itemSize = CGSize(width: 200, height: 200)
        
        collectionView?.registerClass(CollectionViewCell.self, forCellWithReuseIdentifier: ViewController.CellReuseIdentifier)
        collectionView?.indicatorStyle = .White
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(userTappedAddButton(_:)))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.title = "Our Time Machine"
    }
    
    func userTappedAddButton(sender: AnyObject) {
        addNewDate()
    }
    
    func addNewDate() {
        collectionView?.performBatchUpdates({
            let newDate = NSDate()
            self.datesArray.insert(newDate, atIndex: 0)
            
            self.collectionView?.insertItemsAtIndexPaths([NSIndexPath(forItem: 0, inSection: 0)])
            },
                                            completion: nil)
    }
}

// MARK: UICollectionViewDataSource

extension ViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datesArray.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(ViewController.CellReuseIdentifier, forIndexPath: indexPath) as! CollectionViewCell
        cell.text = dateFormatter.stringFromDate(datesArray[indexPath.item])
        return cell
    }
}

